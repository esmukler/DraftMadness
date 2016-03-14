var School = React.createClass({
    handleClick: function(e) {
        e.preventDefault();
        if (!this.props.userInfo.currentOwnerTurn ||
            this.props.school.selected) {
                return;
        }

        var confirmText = 'Are you sure you want to draft ' + this.props.school.name + '?';
        var ans = confirm(confirmText);
        if (!ans) return;

        this.props.createOS(this.props.school.id);
    },

    render: function() {
        var school = this.props.school;

        var classNames = 'school col-md-3 text-center';
        if (school.mine) {
            classNames += ' bg-success';
        } else if (school.selected) {
            classNames += ' bg-danger';
        } else if (this.props.currentOwnerTurn) {
            classNames += ' available';
        }

        var text = `${school.seed}. ${school.name}`;

        return (
            <div onClick={this.handleClick} className={classNames}>
                {text}
            </div>
        );
    }
});

module.exports = School;
