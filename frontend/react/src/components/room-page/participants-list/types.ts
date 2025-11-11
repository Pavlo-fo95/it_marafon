import type { GetParticipantsResponse } from "@types/api";

export interface ParticipantsListProps {
  participants: GetParticipantsResponse;
  isRandomized: boolean;
  currentUserId: number;
  onDeleteParticipant?: (id: number) => void;
}

export interface PersonalInformation {
  firstName: string;
  lastName: string;
  phone: string;
  email?: string;
  deliveryInfo: string;
  link?: string;
}

export type MinParticipant = {
  id: number;
  firstName: string;
  lastName: string;
  phone: string;
  email?: string | null;
  deliveryInfo: string;
  userCode: string;
  isAdmin?: boolean;
};
