import type {Match} from './Match';
import type {Course} from './Course';

export type PlayerSymbol = 'player_one' | 'player_two' | 'player_three' | 'player_four';

export type Player = {
  id: number;
  name: string;
  image_url: string;
  retired?: boolean;
};

export type ComplexPlayer = Player & {
  average_score: number;
  courses: Course[];
  course_records: number;
  leaderboard_position: null | number;
  number_of_matches: number;
  on_fire: boolean;
  perfect_matches: number;
  recent_matches: Match[];
  recent_scores: number[];
  rival_results: Array<{
    name: string;
    results: number[];
  }>;
};
