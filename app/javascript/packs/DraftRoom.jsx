import React from 'react';
import axios from 'axios'
import PropTypes from 'prop-types'
import Owner from './Owner';
import School from './School';

const REGION_NAMES = ['East', 'Midwest', 'South', 'West'];

class DraftRoom extends React.Component {
  state = {
    league: null,
    currentOwner: null,
    schools: [],
    owners: [],
    currentDraftPick: null,
    blockedRegions: [],
    currentOwnerTurn: null,
  };

  componentDidMount() {
    const path = window.location.href;
    const leagueID = path.match(/leagues\/(\d+)\/draft_room/)[1];
    const url = '/api/leagues/' + leagueID + '/draft_room';

    axios
      .get(url)
      .then(resp => {
        const { league, current_owner: currentOwner } = resp.data;
        this.setState({
          league,
          currentOwner,
          currentDraftPick: league.current_draft_pick,
          blockedRegions: currentOwner.regions,
          currentOwnerTurn: currentOwner.turn,
        });
        this.fetchSchools(currentOwner.id);
        this.fetchOwners(league.id);
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

  fetchOwners = leagueID => {
    const url = `/api/leagues/${leagueID}/owners`;

    axios
      .get(url)
      .then(resp => {
        this.setState({ owners: resp.data });
      });
  };

  updateSchool = schoolID => {
    const schools = this.state.schools.map(school => {
      if (school.id === schoolID) {
        return {
          ...school,
          mine: true,
          selected: true,
        };
      }
      return school;
    });
    this.setState({ schools });
  };

  createOS = chosenSchoolID => {
    const url = '/api/owner_schools';

    const data = {
      owner_school: {
        owner_id: this.state.current_owner.id,
        school_id: chosenSchoolID,
        league_id: this.state.league.id,
        draft_pick: this.state.currentDraftPick,
      },
    };

    axios
      .post(url, data)
      .then(data => {
        const { school, current_owner_turn: currentOwnerTurn } = data;
        const schoolID = school.id;
        const currentDraftPick = this.state.currentDraftPick + 1;
        const blockedRegions = this.state.blockedRegions.concat(school.region)

        this.setState({
          currentOwnerTurn,
          currentDraftPick,
          blockedRegions,
        });
        this.updateSchool(schoolID);
        this.fetchOwners();
      });
  };

  renderMessage = () => {
    let messageText;
    let messageClass = 'message text-center';

    if (this.state.currentOwnerTurn) {
      messageText = "It's your turn!";
      messageClass += ' bg-success';
    } else {
      messageText = 'It is NOT your turn.';
    }

    return (
      <div className={messageClass}>
        {messageText}
      </div>
    );
  };

  renderOwners = () => {
    return (
      <div className="owners-container row">
        {this.state.owners.map(owner => (
          <Owner key={owner.id} {...owner} />
        ))}
      </div>
    );
  };

  renderSchools = () => {
    return this.state.schools.map(school => {
      const blockedForUser =
        this.state.currentDraftPick <= 32 &&
        this.state.blockedRegions.includes(school.region);

      return (
        <School
          key={school.id}
          {...school}
          blockedForUser={blockedForUser}
          currentOwnerTurn={this.state.currentOwnerTurn}
          createOS={this.createOS}
        />
      );
    });
  };

  render() {
    return (
      <div className="draft-room">
        {this.renderMessage()}

        <div className="owners container-fluid">
          <div className="section-header">Owners:</div>

          <div className="owners-key row">
            <div className="col-md-4 text-right">
              Key:
            </div>
            <div className="col-md-2 text-center bg-success me">
              Me
            </div>
            <div className="col-md-2 text-center current-turn">
              Current Pick
            </div>
            <div className="col-md-4"></div>
          </div>

          {this.renderOwners()}
        </div>
        <div className="schools container-fluid">
          <div className="section-header">
            Schools:
          </div>

          <div className="schools-key row">
            <div className="col-md-2 text-right">
              Key:
            </div>
            <div className="col-md-2 text-center">
              Available
            </div>
            <div className="col-md-2 text-center bg-success me">
              My Squad
            </div>
            <div className="col-md-2 text-center bg-danger">
              Already Selected
            </div>
            <div className="col-md-2 text-center blocked">
              Blocked*
            </div>
            <div className="col-md-2"></div>
          </div>

          <div className="regions row">
            {REGION_NAMES.map(regionName => (
              <div key={regionName} className="region col-md-3 text-center">
                {regionName}
              </div>
            ))}
          </div>

          <div className="schools-container row">
            {this.renderSchools()}
          </div>

          <em className="pull-right">
            *In the first four rounds, you may only draft
            one school from each region.
          </em>
        </div>
      </div>
    );
  }
};

export default DraftRoom;
