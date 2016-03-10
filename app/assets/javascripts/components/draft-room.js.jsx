var DraftRoom = React.createClass({
    getInitialState: function() {
      return {
        schools: []
      };
    },

    render: function() {
        return (
            <div className="draft-room">
                Here is the draft room Component!
            </div>
        );
    }
});

module.exports = DraftRoom;
