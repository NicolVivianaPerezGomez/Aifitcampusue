import {
  Component,
  OnInit,
  inject,
  signal,
} from '@angular/core';

import {
  NotificacionesService,
  NotificacionApi,
} from '../../../../core/services/notificaciones.service';

@Component({
  selector: 'app-notificaciones',
  templateUrl: './notificaciones.html',
  styleUrl: './notificaciones.css',
})
export class Notificaciones implements OnInit {

  // Servicio para obtener las notificaciones del usuario.
  private readonly notificacionesService =
    inject(NotificacionesService);

  // Lista de notificaciones del usuario.
  readonly notificaciones = signal<NotificacionApi[]>([]);

  // Indica si se están cargando las notificaciones.
  readonly cargando = signal(true);

  async ngOnInit(): Promise<void> {
    await this.cargarNotificaciones();
  }

  private async cargarNotificaciones(): Promise<void> {
    this.cargando.set(true);

    try {
      await this.notificacionesService.cargarMias();
      this.notificaciones.set(
        this.notificacionesService.misNotificaciones(),
      );
    } catch (error) {
      console.error('Error al cargar notificaciones:', error);
      this.notificaciones.set([]);
    } finally {
      this.cargando.set(false);
    }
  }

  formatearDias(dias: string[]): string {
    if (!dias || dias.length === 0) return 'Sin días asignados';
    if (dias.length === 7) return 'Todos los días';
    return dias.join(', ');
  }
}
