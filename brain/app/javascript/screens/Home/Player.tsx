import React from 'react';
import {css, keyframes} from '@emotion/react';
import Heading from 'components/Heading';
import type {Entities} from 'types';

type Props = Entities.MatchLeaderboard[number] & {
  showCrown: boolean;
};

export default function Player({color, image_url, name, score, showCrown}: Props) {
  return (
    <div css={styles.root}>
      <div
        css={css`
          ${styles.player};
        `}
        key={name}
      >
        {image_url && <img css={styles.playerImage} src={image_url} />}
        {showCrown && image_url && <span css={styles.crown}>👑</span>}
        <div
          css={css`
            ${styles.background};
            ${score === 90 && styles.ninety}
            background-color: ${color};
            height: ${score * 1.5}px;
          `}
        />
      </div>
      <Heading css={styles.name} level="3">
        {name}
      </Heading>
    </div>
  );
}

const pulse = keyframes`
  0% {
    box-shadow: 0 0 1.5rem 0.2rem #98d543;
  }
  25% {
    box-shadow: 0 0 1.5rem 0.2rem #3d8be9;
  }
  75% {
    box-shadow: 0 0 1.5rem 0.2rem #f1b950;
  }
  100% {
    box-shadow: 0 0 1.5rem 0.2rem #3d8be9;
  }
`;

const styles = {
  root: css`
    align-items: center;
    display: flex;
    flex-direction: column;
  `,

  background: css`
    border-bottom: 0.3rem solid rgba(0, 0, 0, 0.3);
    border-radius: 0.3rem;
    border-top: 0.2em solid rgba(255, 255, 255, 0.4);
    bottom: 0;
    position: absolute;
    width: 100%;
    z-index: 0;
  `,

  crown: css`
    align-self: flex-start;
    font-size: 6rem;
    position: absolute;
    top: -0.8rem;
    z-index: 2;
  `,

  name: css`
    color: white;
    font-size: 1.6rem;
    margin-top: 1.2rem;
    text-transform: capitalize;
  `,

  ninety: css`
    animation-direction: alternate;
    animation-duration: 1.5s;
    animation-iteration-count: infinite;
    animation-name: ${pulse};
  `,

  player: css`
    align-items: flex-end;
    display: flex;
    height: ${90 * 1.5}px;
    justify-content: center;
    margin: 0 1.4rem;
    position: relative;
    width: ${98 * 1.5}px;
  `,

  playerImage: css`
    padding-bottom: 0.3rem;
    height: 100%;
    z-index: 2;
  `,
};
