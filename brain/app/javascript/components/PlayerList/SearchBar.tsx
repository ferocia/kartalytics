import * as React from 'react';
import {css} from '@emotion/react';
import SearchIcon from 'components/icons/SearchIcon';

type Props = {
  autoFocus?: boolean;
  onInput: (event: React.ChangeEvent<HTMLInputElement>) => void;
  onKeyPress?: (event: React.KeyboardEvent<HTMLInputElement>) => void;
  placeholder: string;
  value: string;
};

export default function SearchBar({autoFocus = true, onInput, onKeyPress, placeholder, value}: Props) {
  return (
    <div css={styles.root}>
      <SearchIcon css={styles.icon} />
      <input
        autoFocus={autoFocus}
        css={styles.searchbar}
        placeholder={placeholder}
        onInput={onInput}
        onKeyPress={onKeyPress}
        value={value}
      ></input>
    </div>
  );
}

const styles = {
  root: css`
    align-items: center;
    border-width: 3px;
    border-color: white;
    display: flex;
    flex: 1;
    margin: 0 auto;
    position: relative;
    width: 40rem;
  `,

  icon: css`
    margin-left: 1.4em;
    position: absolute;
  `,

  searchbar: css`
    background-color: transparent;
    border-color: rgba(255, 255, 255, 0.9);
    border-radius: 4px;
    border-style: solid;
    border-width: 2px;
    color: white;
    font-size: 2em;
    padding: 0.8em;
    padding-left: 2.4em;
    width: 100%;

    &::placeholder {
      color: rgba(255, 255, 255, 0.66);
    }
  `,
};
