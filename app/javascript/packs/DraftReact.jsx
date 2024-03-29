import React from 'react';
import ReactDOM from 'react-dom'
import DraftRoom from './DraftRoom';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <DraftRoom name="React" />,
    document.getElementById('draft-room-container'),
  )
});
