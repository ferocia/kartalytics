import type {PlayerSymbol} from './Player';

export type RaceChart = {
  status: string;
  race_time: number;
  players: Array<{
    player: PlayerSymbol;
    label: string;
    data: Array<{
      position: number;
      item: string;
      timestamp: string;
    }>;
    color: string;
    delta: null | string;
    race_time: null | number;
    pb_set: null | boolean;
    pb_delta: null | number;
    course_record_set: null | boolean;
    course_record_delta: null | number;
  }>;
};
