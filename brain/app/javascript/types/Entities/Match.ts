import type {PlayerSymbol} from './Player';
import type {RaceChart} from './Race';

export type MatchLeaderboard = Array<{
  player: PlayerSymbol;
  position: number;
  score: number;
  color: string;
  name: string;
  image_url: null | string;
  cumulative_race_scores: number[];
}>;

export type Match = {
  id: number;
  created_at: string;
  status: string;
  assigned: boolean;
  started: boolean;
  leaderboard: MatchLeaderboard;
};

export type ComplexMatch = Match & {
  races: Array<{
    id: number;
    course_name: string;
    course_image_url: string;
    chart: RaceChart;
  }>;
};
