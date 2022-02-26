// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import axios from 'axios';
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import DraftRoom from './DraftRoom';

class Hello extends React.Component {
  state = {
    league: null,
    currentOwner: null,
  };

  componentDidMount() {
    const path = window.location.href;
    const leagueID = path.match(/leagues\/(\d+)\/draft_room/)[1];
    const url = '/api/leagues/' + leagueID + '/draft_room';

    axios
      .get(url)
      .then(resp => {
        const { league, current_owner: currentOwner } = resp.data;
        this.setState({ league, currentOwner });
      });
  }

  render() {
    const { league, currentOwner } = this.state;
    return (
      <DraftRoom league={league} currentOwner={currentOwner} />
    );
  }
};

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Hello name="React" />,
    document.body.appendChild(document.createElement('div')),
  )
});
