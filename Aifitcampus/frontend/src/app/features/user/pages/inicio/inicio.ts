import {
  Component,
  ElementRef,
  computed,
  effect,
  inject,
  signal,
  viewChild,
} from '@angular/core';
import { Router } from '@angular/router';
import { formatearDuracion } from '../../../../core/interfaces/ejercicio';
import { PasoRutina, prepararPaso } from '../../../../core/interfaces/paso-rutina';
import { PausasUsuarioService } from '../../../../core/services/pausas-usuario.service';
import { Rutina, RutinasService } from '../../../../core/services/rutinas.service';
import { RelojContador } from '../../../../shared/components/reloj-contador/reloj-contador';

/**
 * Inicio: reproductor de la rutina activa configurada por el administrador.
 * Muestra los ejercicios en el orden, series, repeticiones y descansos de la rutina.
 */
@Component({
  imports: [RelojContador],
  selector: 'app-user-inicio',
  styleUrl: './inicio.css',
  templateUrl: './inicio.html',
})
export class Inicio {
  private readonly rutinasService = inject(RutinasService);
  private readonly pausasService = inject(PausasUsuarioService);
  private readonly router = inject(Router);

  private readonly inicioEn = Date.now();
  private finalizado = false;

  private readonly videoEl = viewChild<ElementRef<HTMLVideoElement>>('videoPlayer');
  private readonly mediaBox = viewChild<ElementRef<HTMLElement>>('mediaBox');

  /** Rutina activa creada por el administrador. */
  readonly rutina = signal<Rutina | null>(null);
  readonly cargando = signal(true);

  /** Ejercicios de la rutina en el orden configurado por el admin. */
  readonly pasos = computed(() =>
    [...(this.rutina()?.exercises ?? [])]
      .sort((a, b) => a.orderIndex - b.orderIndex)
      .map(prepararPaso),
  );

  readonly indice = signal(0);
  readonly serieActual = signal(1);
  readonly enDescanso = signal(false);
  readonly pausado = signal(false);
  readonly sonidoActivo = signal(true);
  readonly timerKey = signal(0);
  readonly vista360 = signal(false);

  readonly formatear = formatearDuracion;

  readonly hayRutina = computed(() => this.pasos().length > 0);

  readonly total = computed(() => this.pasos().length);

  readonly actual = computed((): PasoRutina | null => {
    const lista = this.pasos();
    if (!lista.length) return null;
    return lista[Math.min(this.indice(), lista.length - 1)] ?? null;
  });

  readonly siguiente = computed((): PasoRutina | null => {
    const lista = this.pasos();
    const i = this.indice() + 1;
    return i < lista.length ? lista[i] : null;
  });

  readonly progresoTexto = computed(() => {
    const t = this.total();
    return t ? `${this.indice() + 1} de ${t}` : '—';
  });

  readonly seriesTotales = computed(() => this.actual()?.series ?? 0);

  readonly pctSeries = computed(() => {
    const total = this.seriesTotales();
    if (!total) return 0;
    return (this.serieActual() / total) * 100;
  });

  /** Segundos que debe mostrar el reloj: ejercicio o descanso entre series. */
  readonly segundosPaso = computed(() => {
    const paso = this.actual();
    if (!paso) return 0;
    return this.enDescanso() ? paso.descanso ?? 0 : paso.duracionSegundos;
  });

  readonly etiquetaTiempo = computed(() =>
    this.enDescanso() ? 'Descanso' : 'Tiempo restante',
  );

  constructor() {
    void this.cargarRutina();

    effect(() => {
      const video = this.videoEl()?.nativeElement;
      if (!video) return;
      video.muted = !this.sonidoActivo();
      if (this.pausado()) {
        video.pause();
      } else {
        void video.play().catch(() => undefined);
      }
    });

    effect(() => {
      const len = this.pasos().length;
      if (len === 0) {
        this.indice.set(0);
        return;
      }
      if (this.indice() >= len) {
        this.indice.set(len - 1);
      }
    });
  }

  previewDe(paso: PasoRutina): string {
    return paso.tipoRecurso === 'image' ? paso.urlRecurso ?? '' : '';
  }

  togglePausa(): void {
    if (!this.hayRutina()) return;
    this.pausado.update((v) => !v);
  }

  toggleSonido(): void {
    this.sonidoActivo.update((v) => !v);
  }

  toggleVista360(): void {
    this.vista360.update((v) => !v);
  }

  pantallaCompleta(): void {
    const box = this.mediaBox()?.nativeElement;
    if (!box) return;
    if (document.fullscreenElement) {
      void document.exitFullscreen();
    } else {
      void box.requestFullscreen();
    }
  }

  anterior(): void {
    if (this.indice() <= 0) return;
    this.indice.update((i) => i - 1);
    this.resetPaso();
  }

  siguienteEjercicio(): void {
    const ultimo = this.total() - 1;
    if (ultimo < 0) return;
    if (this.indice() >= ultimo) {
      void this.finalizarRutina();
      return;
    }
    this.indice.update((i) => i + 1);
    this.resetPaso();
  }

  irA(paso: number): void {
    if (paso < 0 || paso >= this.total()) return;
    this.indice.set(paso);
    this.resetPaso();
  }

  /**
   * Fin del reloj actual. Si hay descanso pendiente lo consume; si quedan
   * series repite el ejercicio; si no, pasa al siguiente ejercicio.
   */
  onTiempoAgotado(): void {
    const paso = this.actual();
    if (!paso) return;

    if (this.enDescanso()) {
      this.enDescanso.set(false);
      this.timerKey.update((k) => k + 1);
      this.pausado.set(false);
      return;
    }

    if (this.serieActual() < paso.series) {
      this.serieActual.update((s) => s + 1);
      this.enDescanso.set((paso.descanso ?? 0) > 0);
      this.timerKey.update((k) => k + 1);
      this.pausado.set(false);
      return;
    }

    this.siguienteEjercicio();
  }

  /** Carga la rutina activa (con sus ejercicios) desde el backend. */
  private async cargarRutina(): Promise<void> {
    try {
      this.rutina.set(await this.rutinasService.obtenerRutinaActiva());
    } catch {
      this.rutina.set(null);
    } finally {
      this.cargando.set(false);
    }
  }

  /** Al terminar la secuencia: registra log/auditoría y va a Mis pausas. */
  private async finalizarRutina(): Promise<void> {
    if (this.finalizado) return;
    this.finalizado = true;
    await this.registrarEjecucion();
    await this.pausasService.notificarRutinaCompletada();
    await this.router.navigateByUrl('/user/mis-pausas');
  }

  /** Envía la ejecución al backend para que quede en routine_logs y audits. */
  private async registrarEjecucion(): Promise<void> {
    const rutina = this.rutina();
    if (!rutina) return;
    const durationSeconds = Math.max(0, Math.round((Date.now() - this.inicioEn) / 1000));
    try {
      await this.rutinasService.ejecutar(rutina.id, durationSeconds);
    } catch {
      // Si falla el registro, no se bloquea la navegación a Mis pausas.
    }
  }

  private resetPaso(): void {
    this.serieActual.set(1);
    this.enDescanso.set(false);
    this.pausado.set(false);
    this.vista360.set(false);
    this.timerKey.update((k) => k + 1);
  }
}
