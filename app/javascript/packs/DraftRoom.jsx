import React from 'react';
import PropTypes from 'prop-types'

class DraftRoom extends React.Component {
  render() {
    console.log(this.props);
    return <div>This is the real draft room.</div>;
  }
};

DraftRoom.propTypes = {
  league: PropTypes.shape({}),
  currentOwner: PropTypes.shape({}),
}

export default DraftRoom;
