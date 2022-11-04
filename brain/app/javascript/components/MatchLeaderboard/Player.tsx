import React from 'react';
import {css} from '@emotion/react';
import {Link} from 'react-router-dom';
import PlayerImage from './PlayerImage';
import * as colors from 'styles/colors';
import type {Entities} from 'types';

type Props = Entities.MatchLeaderboard[number] & {
  showCrown: boolean;
  onClick?: (event: React.MouseEvent) => void;
};

export default function Player({showCrown, player, position, name, score, color, image_url, onClick}: Props) {
  const Component: 'div' | React.FC = /player\s/i.test(name)
    ? 'div'
    : props => <Link css={styles.link} to={`/players/${name.toLowerCase()}`} {...props} />;
  const role = Component === 'div' && onClick ? 'button' : undefined;

  return (
    <Component onClick={onClick} role={role}>
      <div
        css={css`
          ${styles.root};
          background-color: ${color};
        `}
      >
        <span css={styles.position}>{position}</span>
        {image_url && <PlayerImage imageUrl={image_url} showCrown={showCrown} />}
        <span css={styles.label}>{name}</span>
        <span css={styles.score}>{score} pts</span>
      </div>
    </Component>
  );
}

const styles = {
  root: css`
    align-items: center;
    border-bottom: 0.3rem solid rgba(0, 0, 0, 0.3);
    border-radius: 0.3rem;
    border-top: 0.2em solid rgba(255, 255, 255, 0.4);
    display: flex;
    height: 4.8em;
    justify-content: space-between;
    margin-bottom: 1.2em;
    padding: 0 1.2em;
    position: relative;
    text-shadow: 0 0.1em rgba(255, 255, 255, 0.3);
  `,

  position: css`
    font-family: 'SuperMario';
    font-size: 3em;
    width: 1.33em;
  `,

  label: css`
    flex: 1;
    font-size: 1.8em;
    font-weight: bold;
    margin-left: 0.75em;
  `,

  link: css`
    color: inherit;
    text-decoration: none;
  `,

  score: css`
    font-size: 2em;
  `,
};
