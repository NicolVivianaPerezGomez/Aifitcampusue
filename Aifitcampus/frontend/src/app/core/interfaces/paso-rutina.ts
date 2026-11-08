import { EjercicioDeRutina } from '../services/rutinas.service';

/** Un ejercicio de la rutina ya preparado para mostrarse o reproducirse. */
export interface PasoRutina {
  clave: string;
  exerciseId: number;
  nombre: string;
  descripcion: string;
  categoria: string;
  duracionSegundos: number;
  series: number;
  repeticiones: number | null;
  descanso: number | null;
  tipoRecurso: 'video' | 'image' | null;
  urlRecurso: string | null;
}

const EXTENSIONES_IMAGEN = /\.(png|jpe?g|gif|webp|svg)(\?.*)?$/i;

/** Convierte un ejercicio de la rutina al modelo que usan las vistas del usuario. */
export function prepararPaso(item: EjercicioDeRutina): PasoRutina {
  const ejercicio = item.exercise;
  const url = ejercicio?.resourceUrl ?? '';
  const esImagen = ejercicio?.resourceType === 'image' || EXTENSIONES_IMAGEN.test(url);

  return {
    clave: `${item.exerciseId}-${item.orderIndex}`,
    exerciseId: item.exerciseId,
    nombre: ejercicio?.name ?? 'Ejercicio',
    descripcion: ejercicio?.description ?? '',
    categoria: ejercicio?.category?.name ?? 'Sin categoría',
    duracionSegundos: Math.max(1, ejercicio?.durationSeconds ?? 0),
    series: Math.max(1, item.sets ?? 1),
    repeticiones: item.reps && item.reps > 0 ? item.reps : null,
    descanso: item.restSeconds && item.restSeconds > 0 ? item.restSeconds : null,
    tipoRecurso: url ? (esImagen ? 'image' : 'video') : null,
    urlRecurso: url || null,
  };
}
