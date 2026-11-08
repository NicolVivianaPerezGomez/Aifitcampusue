import { Component, computed, inject, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { AuthService } from '../../../../core/services/auth.service';
import { prepararPaso } from '../../../../core/interfaces/paso-rutina';
import { Rutina, RutinasService } from '../../../../core/services/rutinas.service';
import { EstadisticasService } from '../../../../core/services/estadisticas.service';
import { GraficoBarras } from '../../../../shared/components/grafico-barras/grafico-barras';
import { TarjetaKpi } from '../../../../shared/components/tarjeta-kpi/tarjeta-kpi';
import { ResumenUsuario } from '../../../../core/interfaces/estadisticas';

/**
 * Dashboard del colaborador: próxima pausa, indicadores y ejercicios del bloque.
 */
@Component({
  imports: [RouterLink, TarjetaKpi, GraficoBarras],
  selector: 'app-user-dashboard',
  styleUrl: './dashboard.css',
  templateUrl: './dashboard.html',
})
export class Dashboard {
  private readonly auth = inject(AuthService);
  private readonly estadisticas = inject(EstadisticasService);
  private readonly rutinasService = inject(RutinasService);

  readonly usuario = this.auth.usuarioActual;
  readonly resumen = signal<ResumenUsuario | null>(null);
  readonly rutina = signal<Rutina | null>(null);

  readonly pasos = computed(() =>
    [...(this.rutina()?.exercises ?? [])]
      .sort((a, b) => a.orderIndex - b.orderIndex)
      .map(prepararPaso),
  );

  constructor() {
    void this.cargar();
  }

  async cargar(): Promise<void> {
    const nombre = this.usuario()?.nombre ?? 'Usuario';
    const [data] = await Promise.all([
      this.estadisticas.obtenerResumenUsuario(nombre),
      this.cargarRutina(),
    ]);
    this.resumen.set(data);
  }

  private async cargarRutina(): Promise<void> {
    try {
      this.rutina.set(await this.rutinasService.obtenerRutinaActiva());
    } catch {
      this.rutina.set(null);
    }
  }
}
