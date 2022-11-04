import React from 'react';
import {css} from '@emotion/react';
import * as colors from 'styles/colors';

type Props = {
  children: React.ReactNode;
  className?: string;
  color?: keyof typeof colors;
  level?: '1' | '2' | '3';
};

export default function Heading({level = '1', color = 'white', children, className}: Props) {
  const overrideStyles = css`
    color: ${colors[color]};
  `;

  switch (level) {
    case '1':
      return (
        <h1 className={className} css={[styles.h1, overrideStyles]}>
          {children}
        </h1>
      );
    case '2':
      return (
        <h2 className={className} css={[styles.h2, overrideStyles]}>
          {children}
        </h2>
      );
    case '3':
      return (
        <h3 className={className} css={[styles.h3, overrideStyles]}>
          {children}
        </h3>
      );
    default:
      return null;
  }
}

const styles = {
  h1: css`
    font-size: 3.2rem;
    font-weight: bold;
  `,

  h2: css`
    font-size: 2.4rem;
    font-weight: bold;
  `,

  h3: css`
    font-size: 1.8rem;
    font-weight: bold;
  `,
};
