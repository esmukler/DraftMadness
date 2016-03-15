var School = require('./draft-room/school');
var Owner = require('./draft-room/owner');

var DraftRoom = React.createClass({
    getInitialState: function() {
      return {
        schools: [],
        owners: [],
        currentDraftPick: this.props.league.current_draft_pick,
        blockedRegions: this.props.current_owner.regions,
        currentOwnerTurn: this.props.current_owner.turn
      };
    },

    fetchSchools: function() {
      var url = '/api/schools/bracket';

      $.ajax(url, {
          type: 'GET',
          dataType: 'json',
          data: {
            current_owner_id: this.props.current_owner.id
          },
          success: function(data) {
              this.setState({
                  schools: data
              })
          }.bind(this)
      });
    },

    fetchOwners: function() {
      var url = '/api/leagues/' + this.props.league.id + '/owners';

      $.ajax(url, {
          type: 'GET',
          dataType: 'json',
          success: function(data) {
              this.setState({
                  owners: data
              })
          }.bind(this)
      });
    },

    componentWillMount: function() {
      this.fetchSchools();
      this.fetchOwners();
    },

    updateSchool: function(schoolID) {
        var schools = this.state.schools.map(function(el) {
            if (el.id === schoolID) {
                el.mine = true;
                el.selected = true;
            }
            return el
        })
        this.setState({
            schools: schools
        })
    },

    createOS: function(chosenSchoolID) {
        var url = '/api/owner_schools';

        var data = {
            owner_school: {
                owner_id: this.props.current_owner.id,
                school_id: chosenSchoolID,
                league_id: this.props.league.id,
                draft_pick: this.props.league.current_draft_pick
            }
        }

        $.ajax(url, {
            type: 'POST',
            dataType: 'json',
            data: data,
            success: function(data) {
                var schoolID = data.school.id;
                var currentDraftPick = this.state.currentDraftPick + 1;
                var blockedRegions = this.state.blockedRegions.concat(data.school.region)

                this.setState({
                  currentOwnerTurn: data.current_owner_turn,
                  currentDraftPick: currentDraftPick,
                  blockedRegions: blockedRegions
                });
                this.updateSchool(schoolID);
                this.fetchOwners();
            }.bind(this)
        });
    },

    render: function() {
        var messageText;
        var messageClass = 'message text-center';

        if (this.state.currentOwnerTurn) {
            messageText = "It's your turn!";
            messageClass += ' bg-success';
        } else {
            messageText = 'It is NOT your turn.';
        }

        var message = (
            <div className={messageClass}>
                {messageText}
            </div>
        );

        var owners = this.state.owners.map(function(owner) {
            return <Owner key={owner.id} owner={owner} />
        })

        var schools = this.state.schools.map(function(school) {
            var blockedForUser;
            if (this.state.currentDraftPick <= 32 &&
                this.state.blockedRegions.indexOf(school.region) !== -1
            ) {
                blockedForUser = true;
            }

            return <School
                key={school.id}
                blockedForUser={blockedForUser}
                currentOwnerTurn={this.state.currentOwnerTurn}
                school={school}
                createOS={this.createOS}
            />;
        }.bind(this));

        var regionNames = ['East', 'Midwest', 'South', 'West'];
        var regions = regionNames.map(function(regionName) {
            return (
              <div className="region col-md-3 text-center">
                {regionName}
              </div>
            )
        })

        return (
            <div className="draft-room">
                {message}

                <div className="owners container-fluid">
                    <div className="section-header">
                        Owners:
                    </div>

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

                    <div className="owners-container row">
                        {owners}
                    </div>
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
                        {regions}
                    </div>

                    <div className="schools-container row">
                        {schools}
                    </div>
                    <em className="pull-right">
                        *In the first four rounds, you may only draft
                        one school from each region.
                    </em>
                </div>
            </div>
        );
    }
});

module.exports = DraftRoom;
