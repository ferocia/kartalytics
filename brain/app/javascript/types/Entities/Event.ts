import type {Match} from './Match';
import type {Player} from './Player';
import type {RaceChart} from './Race';

export type Event = {
  title: string;
  match?: Match;
  race?: RaceChart & {
    course_name: string;
    course_image: string;
    course_champion: null | string;
    course_best_time: null | number;
    course_top_records?: Array<{
      player_name: string;
      race_time: number;
    }>;
    course_top_players?: Array<{
      player_name: string;
      wins: number;
      games: number;
      ratio: number;
    }>;
  };
};

export type EventSelectPlayers = {
  players: Player[];
  show_double_down: boolean;
  previous_matches_in_a_row: number;
};
