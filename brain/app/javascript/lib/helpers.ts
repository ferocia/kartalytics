import {format, parseISO} from 'date-fns';

export function formatTime<T>(time: T) {
  if (time == null) {
    return '';
  } else if (typeof time === 'number') {
    return `${time.toFixed(2)}s`;
  }

  return time;
}

export function formatDate(date: string): string {
  return format(parseISO(date), 'p, PPPP');
}
