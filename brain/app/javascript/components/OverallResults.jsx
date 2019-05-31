import React from "react";

const OverallResult = ({ player, position, label, score, color }) => {
  return (
    <div className="player" style={{ backgroundColor: color }}>
      <span className="player_position">{position}</span>
      <span className="player_name">{label}</span>
      <span className="player_score">{`${score} pts`}</span>
    </div>
  );
};

const OverallResults = ({ leaderboard }) => {
  return (
    <div className="overall_result">
      {leaderboard.map((player, index) => (
        <OverallResult key={index} {...player} />
      ))}
    </div>
  );
}

export default OverallResults;
