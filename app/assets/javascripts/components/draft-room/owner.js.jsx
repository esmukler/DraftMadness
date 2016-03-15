var School = React.createClass({
    getInitialState: function() {
      return {
        currentTurn: this.props.current_turn,
        isCurrentUser: this.props.is_current_user
      };
    },

    render: function() {
        var props = this.props.owner;
        var classNames = 'owner col-md-3 text-center';
        classNames += props.is_current_user ? ' bg-success' : '';
        classNames += props.current_turn ? ' current-turn' : '';

        var text = this.props.owner.name + ' (' + this.props.owner.draft_pick + ')';

        return (
            <div className={classNames}>
                <a href={this.props.owner.url}>{text}</a>
            </div>
        );
    }
});

module.exports = School;
