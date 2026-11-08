import { Component, OnInit, computed, inject, signal } from '@angular/core';
import { AuditoriaService, AuditEntry, AuditFilter } from '../../../../core/services/auditoria.service';
import { mensajeError } from '../../../../core/services/api-error';

type EstadoUsuario = 'todos' | 'activos' | 'inactivos';
type EntidadAuditoria = '' | 'routine_logs' | 'exercises';

const ACCIONES_POR_ENTIDAD: Record<EntidadAuditoria, string[]> = {
  '': ['CREATE', 'UPDATE', 'DELETE', 'ACTIVATE', 'DEACTIVATE', 'COMPLETE', 'ABANDON'],
  routine_logs: ['COMPLETE', 'ABANDON'],
  exercises: ['CREATE', 'DELETE', 'UPDATE', 'ACTIVATE', 'DEACTIVATE'],
};

/**
 * Auditoría: listado de acciones registradas en el sistema.
 * Datos del backend: GET /api/audits
 */
@Component({
  selector: 'app-admin-auditoria',
  styleUrl: './admin-auditoria.css',
  templateUrl: './admin-auditoria.html',
})
export class AdminAuditoria implements OnInit {
  private readonly auditoriaService = inject(AuditoriaService);

  readonly registros = signal<AuditEntry[]>([]);
  readonly cargando = signal(true);
  readonly error = signal('');

  readonly estadoUsuario = signal<EstadoUsuario>('todos');
  readonly entidad = signal<EntidadAuditoria>('');
  readonly accion = signal('');

  /** Acciones válidas según la entidad seleccionada. */
  readonly accionesDisponibles = computed(() => ACCIONES_POR_ENTIDAD[this.entidad()]);

  async ngOnInit(): Promise<void> {
    await this.cargar();
  }

  async cargar(): Promise<void> {
    this.cargando.set(true);
    this.error.set('');
    try {
      const filtro: AuditFilter = { limit: 100 };
      const estado = this.estadoUsuario();
      if (estado !== 'todos') filtro.userActive = estado === 'activos';
      if (this.entidad()) filtro.entity = this.entidad();
      if (this.accion()) filtro.action = this.accion();

      this.registros.set(await this.auditoriaService.listar(filtro));
    } catch (error) {
      this.error.set(mensajeError(error, 'No fue posible cargar la auditoría.'));
    } finally {
      this.cargando.set(false);
    }
  }

  cambiarEstadoUsuario(valor: string): void {
    this.estadoUsuario.set(valor as EstadoUsuario);
    void this.cargar();
  }

  cambiarEntidad(valor: string): void {
    const entidad = valor as EntidadAuditoria;
    this.entidad.set(entidad);
    if (!ACCIONES_POR_ENTIDAD[entidad].includes(this.accion())) {
      this.accion.set('');
    }
    void this.cargar();
  }

  cambiarAccion(valor: string): void {
    this.accion.set(valor);
    void this.cargar();
  }

  limpiarFiltros(): void {
    this.estadoUsuario.set('todos');
    this.entidad.set('');
    this.accion.set('');
    void this.cargar();
  }

  formatearFecha(fecha: string | null): string {
    if (!fecha) return '—';
    return new Date(fecha).toLocaleString('es-CO', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  }
}
