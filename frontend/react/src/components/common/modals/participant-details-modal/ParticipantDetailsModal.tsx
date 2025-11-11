import PersonalInformation from "@components/common/personal-information/PersonalInformation";
import Modal from "../modal/Modal";
import type { ParticipantDetailsModalProps } from "./types";

const ParticipantDetailsModal = ({
  isOpen = false,
  onClose,
  personalInfoData,
}: ParticipantDetailsModalProps) => {
  return (
    <Modal
      title="Participant Details"
      description="Everything about your Secret Nick player!"
      iconName="cookie"
      isOpen={isOpen}
      onClose={onClose}
      onConfirm={onClose}
    >
      <PersonalInformation
        firstName={personalInfoData.firstName}
        lastName={personalInfoData.lastName}
        phone={personalInfoData.phone}
        email={personalInfoData.email ?? ""}
        deliveryInfo={personalInfoData.deliveryInfo}
        withoutHeader
      />
    </Modal>
  );
};

export default ParticipantDetailsModal;
