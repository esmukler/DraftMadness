var School = require('./draft-room/school');
var Owner = require('./draft-room/owner');

var DraftRoom = React.createClass({
    getInitialState: function() {
      return {
        schools: [],
        owners: [],
        currentOwnerTurn: this.props.currentOwnerTurn
      };
    },

    fetchSchools: function() {
      var url = '/api/schools/bracket';

      $.ajax(url, {
          type: 'GET',
          dataType: 'json',
          data: {
            current_owner_id: this.props.currentOwnerID
          },
          success: function(data) {
              this.setState({
                  schools: data
              })
          }.bind(this)
      });
    },

    fetchOwners: function() {
      var url = `/api/leagues/${this.props.leagueID}/owners`;

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
                owner_id: this.props.currentOwnerID,
                school_id: chosenSchoolID,
                league_id: this.props.leagueID,
                draft_pick: this.props.currentDraftPick
            }
        }

        $.ajax(url, {
            type: 'POST',
            dataType: 'json',
            data: data,
            success: function(data) {
                var schoolID = data.school.id;

                this.setState({
                  currentOwnerTurn: data.current_owner_turn
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
            return <School
                key={school.id}
                userInfo={this.props}
                currentOwnerTurn={this.state.currentOwnerTurn}
                school={school}
                createOS={this.createOS}
            />;
        }.bind(this));

        var regionNames = ['South', 'West', 'East', 'Midwest'];
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
                    <div className="owners-container row">
                        {owners}
                    </div>
                </div>

                <div className="schools container-fluid">
                    <div className="section-header">
                        Schools:
                    </div>
                    <div className="regions row">
                        {regions}
                    </div>
                    <div className="schools-container row">
                        {schools}
                    </div>
                </div>
            </div>
        );
    }
});

module.exports = DraftRoom;
