import React, {useState} from 'react';
import {css} from '@emotion/react';
import * as colors from 'styles/colors';
import rocky from 'images/rocky-wrench.png';

/**
 * Simulates events from the analyser
 */
export default function DevTools() {
  const [isOpen, setIsOpen] = useState(false);

  function handleClickMainMenuScreen() {
    ingest({event_type: 'main_menu_screen'});
  }

  function handleClickSelectCharacterScreen() {
    ingest({event_type: 'select_character_screen'});
  }

  function handleClickIntroScreen() {
    ingest({
      event_type: 'intro_screen',
      data: {
        course_name: 'Big Blue',
      },
    });
  }

  function handleClickRaceScreen() {
    ingest({
      event_type: 'race_screen',
      data: {
        player_one: {position: getRandomPosition()},
        player_two: {position: getRandomPosition()},
        player_three: {position: getRandomPosition()},
        player_four: {position: getRandomPosition()},
      },
    });
  }

  function handleClickRaceResultScreen() {
    ingest({
      event_type: 'race_result_screen',
      data: {
        player_one: {position: getRandomPosition(), points: 12},
        player_two: {position: getRandomPosition(), points: 10},
        player_three: {position: getRandomPosition(), points: 6},
        player_four: {position: getRandomPosition(), points: 2},
      },
    });
  }

  function handleClickMatchResultScreen() {
    ingest({
      event_type: 'match_result_screen',
      data: {
        player_one: {position: 8, score: 23},
        player_two: {position: 2, score: 62},
        player_three: {position: 1, score: 90},
        player_four: {position: 5, score: 46},
      },
    });
  }

  return (
    <div css={styles.root}>
      {isOpen && (
        <div css={styles.menu}>
          <button onClick={handleClickMainMenuScreen}>main_menu_screen</button>
          <button onClick={handleClickSelectCharacterScreen}>select_character_screen</button>
          <button onClick={handleClickIntroScreen}>intro_screen</button>
          <button onClick={handleClickRaceScreen}>race_screen</button>
          <button onClick={handleClickRaceResultScreen}>race_result_screen</button>
          <button onClick={handleClickMatchResultScreen}>match_result_screen</button>
        </div>
      )}
      <img
        css={styles.rocky}
        onClick={() => setIsOpen(isOpen => !isOpen)}
        role="button"
        src={rocky}
        title="Kartalytics DevTools"
        width="80"
      />
    </div>
  );
}

type Event = {
  event_type:
    | 'main_menu_screen'
    | 'select_character_screen'
    | 'intro_screen'
    | 'race_screen'
    | 'race_result_screen'
    | 'match_result_screen';
  data?: Record<string, unknown>;
};

function ingest(event: Event) {
  fetch('/api/kartalytics/ingest', {
    method: 'post',
    headers: {'content-type': 'application/json'},
    body: JSON.stringify({
      events: [{...event, timestamp: new Date().toISOString()}],
    }),
  }).catch(e => {
    // hey
  });
}

function getRandomPosition() {
  return Math.floor(Math.random() * 12) + 1;
}

const styles = {
  root: css`
    position: fixed;
    right: 2rem;
    bottom: 2rem;
    z-index: 999;
  `,

  rocky: css`
    float: right;
    cursor: pointer;
  `,

  menu: css`
    display: flex;
    flex-direction: column;
    padding: 1rem;
    background: ${colors.blue};
    border-radius: 0.3rem;

    button {
      margin: 0.5rem;
      padding: 0.5rem 1rem;
      background: ${colors.yellow};
      outline: none;
      border: none;
      box-shadow: 0.5rem 0.5rem ${colors.black};
      color: ${colors.black};
      font-family: Circular, sans-serif;
      cursor: pointer;

      &:hover,
      &:focus {
        transform: scale(1.02);
      }

      &:active {
        background: ${colors.red};
      }
    }
  `,
};
