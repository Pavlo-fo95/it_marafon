export interface ParticipantCardProps {
  firstName: string;
  lastName: string;
  isCurrentUser?: boolean;
  isAdmin?: boolean;
  isCurrentUserAdmin?: boolean;
  adminInfo?: string;
  participantLink?: string;

  onInfoButtonClick?: () => void;

  showDelete?: boolean;
  onDeleteClick?: () => void;
}
