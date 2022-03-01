import React from 'react';
import axios from 'axios'
import PropTypes from 'prop-types'

class DraftRoom extends React.Component {
  state = {
    league: null,
    currentOwner: null,
    schools: [],
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
        this.fetchSchools(currentOwner.id);
      });

  }

    fetchSchools = currentOwnerID => {
      const url = '/api/schools/bracket';

      axios
        .get(url, { params: { current_owner_id: currentOwnerID } })
        .then(resp => {
          this.setState({ schools: resp.data });
      });
    };
  //
  //     fetchOwners: function() {
  //       var url = '/api/leagues/' + this.props.league.id + '/owners';
  //
  //       $.ajax(url, {
  //           type: 'GET',
  //           dataType: 'json',
  //           success: function(data) {
  //               this.setState({
  //                   owners: data
  //               })
  //           }.bind(this)
  //       });
  //     },

  render() {
    const { league, currentOwner, schools } = this.state;
    return (
      <div>
        {Object.values(this.state).map(values => {
          return (
            <div>
              {JSON.stringify(values)}
            </div>
          )
        })}
      </div>
    );
  }
};

DraftRoom.propTypes = {
  league: PropTypes.shape({}),
  currentOwner: PropTypes.shape({}),
}

export default DraftRoom;
