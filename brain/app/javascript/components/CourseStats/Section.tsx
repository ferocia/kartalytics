import React from 'react';
import {css} from '@emotion/react';
import Records from './Records';
import * as colors from 'styles/colors';

type Props = {
  title: string;
  titleColor?: keyof typeof colors;
  records: Array<{
    player_name: string;
    value: string | number;
  }>;
};

export default function Section({title, titleColor = 'yellow', records}: Props) {
  return (
    <div css={styles.root}>
      <h3
        css={css`
          ${styles.title};
          color: ${colors[titleColor]};
        `}
      >
        {title}
      </h3>
      <Records records={records} />
    </div>
  );
}

const styles = {
  root: css`
    &:first-of-type {
      flex: 0.41;
    }

    &:last-of-type {
      flex: 0.56;
    }
  `,

  title: css`
    -webkit-text-stroke: 0.1rem rgba(255, 255, 255, 0.2);
    font-family: SuperMario;
    font-size: 4.8rem;
    margin: 0 0 -0.25em 0;
  `,
};
