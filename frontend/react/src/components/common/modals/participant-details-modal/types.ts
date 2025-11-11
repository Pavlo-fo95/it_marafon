import type { PersonalInformation } from "@components/room-page/participants-list/types";

export type ParticipantDetailsModalProps = {
  isOpen: boolean;
  onClose: () => void;
  personalInfoData: PersonalInformation;
};
