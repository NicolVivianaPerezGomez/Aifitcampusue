import { Component, OnInit, computed, inject, signal } from '@angular/core';
import { Router } from '@angular/router';
import { formatearDuracion } from '../../../../core/interfaces/ejercicio';
import { prepararPaso } from '../../../../core/interfaces/paso-rutina';
import { Rutina, RutinasService } from '../../../../core/services/rutinas.service';

/**
 * Rutina activa: los ejercicios que el administrador configuró para las pausas.
 */
@Component({
  selector: 'app-user-ejercicios',
  styleUrl: './ejercicios.css',
  templateUrl: './ejercicios.html',
})
export class Ejercicios implements OnInit {
  private readonly rutinasService = inject(RutinasService);
  private readonly router = inject(Router);

  readonly rutina = signal<Rutina | null>(null);
  readonly cargando = signal(true);

  readonly pasos = computed(() =>
    [...(this.rutina()?.exercises ?? [])]
      .sort((a, b) => a.orderIndex - b.orderIndex)
      .map(prepararPaso),
  );

  readonly formatear = formatearDuracion;

  async ngOnInit(): Promise<void> {
    try {
      this.rutina.set(await this.rutinasService.obtenerRutinaActiva());
    } catch {
      this.rutina.set(null);
    } finally {
      this.cargando.set(false);
    }
  }

  iniciar(): void {
    void this.router.navigateByUrl('/sesion');
  }
}
