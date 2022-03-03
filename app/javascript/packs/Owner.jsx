import React from 'react';
import PropTypes from 'prop-types'

const Owner = ({ name, draft_pick, url, is_current_user, current_turn }) => {
  let classNames = 'owner col-md-3 text-center';
  if (is_current_user) {
    classNames += ' bg-success';
  }

  if (current_turn) {
    classNames += ' current-turn';
  }

  const text = `${name} (${draft_pick})`;

  return (
    <div className={classNames}>
      <a href={url}>{text}</a>
    </div>
  );
};

Owner.propTypes = {
  name: PropTypes.string.isRequired,
  draft_pick: PropTypes.number.isRequired,
  url: PropTypes.string.isRequired,
  is_current_user: PropTypes.bool.isRequired,
  current_turn: PropTypes.bool.isRequired,
}

export default Owner;
