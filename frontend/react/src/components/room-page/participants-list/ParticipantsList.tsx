import { useState } from "react";
import { useParams } from "react-router";

import ParticipantCard from "@components/common/participant-card/ParticipantCard";
import ParticipantDetailsModal from "@components/common/modals/participant-details-modal/ParticipantDetailsModal";
import Modal from "@components/common/modals/modal/Modal";

import {
  MAX_PARTICIPANTS_NUMBER,
  generateParticipantLink,
} from "@utils/general";

import type {
  ParticipantsListProps,
  PersonalInformation,
  MinParticipant,
} from "./types";

import "./ParticipantsList.scss";

const ParticipantsList = ({
  participants,
  isRandomized,
  currentUserId,
  onDeleteParticipant,
}: ParticipantsListProps) => {
  const { userCode } = useParams();

  const [selectedParticipant, setSelectedParticipant] =
    useState<PersonalInformation | null>(null);

  // кто я и есть ли права админа
  const currentUser = participants?.find((p) => p.userCode === userCode);
  const isCurrentUserAdmin = !!currentUser?.isAdmin;

  // разнести админа и остальных
  const admin = participants?.find((p) => p.isAdmin);
  const restParticipants = participants?.filter((p) => !p.isAdmin) ?? [];

  const isParticipantsMoreThanTen = (participants?.length ?? 0) > 10;

  const handleInfoButtonClick = (participant: MinParticipant) => {
    const personalInfoData: PersonalInformation = {
      firstName: participant.firstName,
      lastName: participant.lastName,
      phone: participant.phone,
      deliveryInfo: participant.deliveryInfo,
      email: participant.email ?? undefined,
      link: generateParticipantLink(participant.userCode),
    };
    setSelectedParticipant(personalInfoData);
  };

  const handleModalClose = () => setSelectedParticipant(null);

  // условия показа корзины
  const canShowDelete = (participantId: number) =>
    isCurrentUserAdmin &&
    !isRandomized &&
    participantId !== (currentUserId ?? 0);

  // состояние подтверждения удаления
  const [confirmId, setConfirmId] = useState<number | null>(null);
  const openConfirm = (id: number) => setConfirmId(id);
  const closeConfirm = () => setConfirmId(null);
  const confirmDelete = async () => {
    if (confirmId == null) return;
    await onDeleteParticipant?.(confirmId);
    setConfirmId(null);
  };

  return (
    <div
      className={`participant-list ${
        isParticipantsMoreThanTen ? "participant-list--shift-bg-image" : ""
      }`}
    >
      <div
        className={`participant-list__content ${
          isParticipantsMoreThanTen
            ? "participant-list__content--extra-padding"
            : ""
        }`}
      >
        <div className="participant-list-header">
          <h3 className="participant-list-header__title">Who’s Playing?</h3>
          <span className="participant-list-counter__current">
            {participants?.length ?? 0}/
          </span>
          <span className="participant-list-counter__max">
            {MAX_PARTICIPANTS_NUMBER}
          </span>
        </div>

        <div className="participant-list__cards">
          {/* карточка админа */}
          {admin ? (
            <ParticipantCard
              key={admin.id}
              firstName={admin.firstName}
              lastName={admin.lastName}
              isCurrentUser={userCode === admin.userCode}
              isAdmin={!!admin.isAdmin}
              isCurrentUserAdmin={userCode === admin.userCode}
              adminInfo={`${admin.phone}${admin.email ? `\n${admin.email}` : ""}`}
              participantLink={generateParticipantLink(admin.userCode)}
            />
          ) : null}

          {/* остальные */}
          {restParticipants.map((user) => (
            <ParticipantCard
              key={user.id}
              firstName={user.firstName}
              lastName={user.lastName}
              isCurrentUser={userCode === user.userCode}
              isCurrentUserAdmin={userCode === admin?.userCode}
              participantLink={generateParticipantLink(user.userCode)}
              onInfoButtonClick={
                userCode === admin?.userCode && userCode !== user.userCode
                  ? () => handleInfoButtonClick(user as MinParticipant)
                  : undefined
              }
              onDeleteClick={
                canShowDelete(user.id) ? () => openConfirm(user.id) : undefined
              }
            />
          ))}
        </div>

        {/* модалка деталей участника */}
        {selectedParticipant && (
          <ParticipantDetailsModal
            isOpen
            onClose={handleModalClose}
            personalInfoData={selectedParticipant}
          />
        )}

        {/* модалка подтверждения удаления */}
        {confirmId !== null && (
          <Modal
            title="Remove participant?"
            description="This user will be removed from the room. They can join again using the invitation link."
            iconName="note"
            isOpen
            onClose={closeConfirm}
            onConfirm={confirmDelete}
          >
            <p>Are you sure you want to remove this participant?</p>
          </Modal>
        )}
      </div>
    </div>
  );
};

export default ParticipantsList;
