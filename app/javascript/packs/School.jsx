import React from 'react';
import PropTypes from 'prop-types'

const School = ({
  id,
  seed,
  name,
  selected,
  mine,
  currentOwnerTurn,
  blockedForUser,
  createOS,
}) => {
  const handleClick = e => {
    e.preventDefault();

    if (!currentOwnerTurn || selected || blockedForUser) return;

    const confirmText = `Are you sure you want to draft ${name}?`;
    const ans = confirm(confirmText);
    if (!ans) return;

    createOS(id);
  };

  let classNames = 'school col-md-3 text-center';
  if (mine) {
    classNames += ' bg-success';
  } else if (selected) {
    classNames += ' bg-danger';
  } else if (blockedForUser) {
    classNames += ' blocked';
  } else if (currentOwnerTurn) {
    classNames += ' available';
  }

  return (
    <div onClick={handleClick} className={classNames}>
      {`${seed}. ${name}`}
    </div>
  );
};

School.propTypes = {
  id: PropTypes.number.isRequired,
  seed: PropTypes.number.isRequired,
  name: PropTypes.string.isRequired,
  selected: PropTypes.bool.isRequired,
  mine: PropTypes.bool.isRequired,
  currentOwnerTurn: PropTypes.bool.isRequired,
  blockedForUser: PropTypes.bool.isRequired,
  createOS: PropTypes.func.isRequired,
}

export default School;
