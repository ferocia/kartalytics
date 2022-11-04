import React from 'react';
import {css} from '@emotion/react';
import * as colors from 'styles/colors';

type Props = {
  imageUrl: string;
};

export default function CourseImage({imageUrl}: Props) {
  return (
    <div css={styles.root}>
      <img css={styles.image} key={imageUrl} src={imageUrl} width="386" height="217" />
    </div>
  );
}

const styles = {
  root: css`
    margin: 2rem 0;
    border: 0.2rem solid ${colors.orange};
    border-radius: 0.3rem;
  `,

  image: css`
    display: block;
    width: 100%;
    height: auto;
  `,
};
