import ItemCard from "../item-card/ItemCard";
import CopyButton from "../copy-button/CopyButton";
import InfoButton from "../info-button/InfoButton";
import IconButton from "../icon-button/IconButton";

import type { ParticipantCardProps } from "./types";
import "./ParticipantCard.scss";

const ParticipantCard = ({
  firstName,
  lastName,
  isCurrentUser = false,
  isAdmin = false,
  isCurrentUserAdmin = false,
  adminInfo = "",
  participantLink = "",
  onInfoButtonClick,
  onDeleteClick,
}: ParticipantCardProps) => {
  return (
    <ItemCard title={`${firstName} ${lastName}`} isFocusable>
      <div className="participant-card-info-container">
        {/* слева — "You"/"Admin" */}
        {isCurrentUser && <p className="participant-card-role">You</p>}
        {!isCurrentUser && isAdmin && (
          <p className="participant-card-role">Admin</p>
        )}

        {/* справа — блок иконок */}
        <div className="participant-card-icons">
          {isCurrentUserAdmin && (
            <CopyButton
              textToCopy={participantLink}
              iconName="link"
              successMessage="Personal Link is copied!"
              errorMessage="Personal Link was not copied. Try again."
            />
          )}

          {isCurrentUserAdmin && !isAdmin && onInfoButtonClick && (
            <InfoButton withoutToaster onClick={onInfoButtonClick} />
          )}

          {!isCurrentUser && isAdmin && <InfoButton infoMessage={adminInfo} />}

          {/* корзина — показываем только если передан обработчик */}
          {onDeleteClick && (
            <IconButton
              iconName="trash"
              color="green"
              onClick={onDeleteClick}
              aria-label="Delete participant"
              title="Delete participant"
            />
          )}
        </div>
      </div>
    </ItemCard>
  );
};

export default ParticipantCard;
