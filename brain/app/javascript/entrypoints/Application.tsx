import React from 'react';
import ReactDOM from 'react-dom';
import {QueryClient, QueryClientProvider} from '@tanstack/react-query';
import {BrowserRouter, Route, Routes} from 'react-router-dom';
import Event from 'screens/Event';
import Home from 'screens/Home';
import Leaderboard from 'screens/Leaderboard';
import Match from 'screens/Match';
import Player from 'screens/Player';
import Players from 'screens/Players';
import Courses from 'screens/Courses';
import Course from 'screens/Course';

const queryClient = new QueryClient();

export default function App() {
  const router = (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/event" element={<Event />} />
        <Route path="/kartalytics_matches/:id" element={<Match />} />
        <Route path="/leaderboard" element={<Leaderboard />} />
        <Route path="/players" element={<Players />} />
        <Route path="/players/:name" element={<Player />} />
        <Route path="/courses" element={<Courses />} />
        <Route path="/courses/:name" element={<Course />} />
      </Routes>
    </BrowserRouter>
  );

  return <QueryClientProvider client={queryClient}>{router}</QueryClientProvider>;
}

ReactDOM.render(<App />, document.getElementById('root'));
