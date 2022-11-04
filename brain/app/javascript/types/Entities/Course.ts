import type {Player} from './Player';

export type CourseRecord = {
  id: number;
  player_name: string;
  race_time: number;
};

export type Course = {
  id: number;
  name: string;
  image: string;
  champion: null | Player;
};

export type ComplexCourse = Course & {
  best_time: null | number;
  top_players: Array<{
    player_name: string;
    games: number;
    wins: number;
    ratio: number;
  }>;
  top_records: CourseRecord[];
  uniq_top_records: CourseRecord[];
};
