import React from 'react';
import {css} from '@emotion/react';
import {CUPS} from 'lib/cups';

type Props = {
  completedTracks: string[];
};

export default function TrackBadges({completedTracks}: Props) {
  return <div css={styles.achievements}>{Achievements(completedTracks)}</div>;
}

function Achievements(completedCourses: string[]) {
  return CUPS.map(cup => {
    const numCompleted = completedCourses.filter(course => cup.tracks.includes(course)).length;
    return (
      <div key={cup.subheading}>
        <img
          css={[styles.achievementImage, numCompleted !== 4 && styles.grayScale]}
          src={cup.image}
          title={cup.tracks.join(', ')}
        />
        <div css={styles.achievementText}>
          {cup.subheading}
          <br />({numCompleted}/4)
        </div>
      </div>
    );
  });
}

const styles = {
  achievements: css`
    display: flex;
    flex-wrap: wrap;
  `,

  achievementImage: css`
    width: 10rem;
    padding: 1rem;
  `,

  achievementText: css`
    font-size: 1.2em;
    line-height: 1.5;
    text-align: center;
  `,

  grayScale: css`
    filter: grayscale(100%);
  `,
};
