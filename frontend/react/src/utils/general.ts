import type { ShowToaster } from "@components/common/toaster/types";
import config from "../../config.json";

const { protocol, host } = window.location;

/**
 * Источник BASE_API_URL:
 * 1) import.meta.env.VITE_API_URL — берётся из .env / .env.production при билде Vite
 * 2) config.json → environment.backendApiUrl — fallback
 * 3) "http://localhost:8080" — дефолт для совсем локального дев-режима
 */
export const BASE_API_URL =
  import.meta.env.VITE_API_URL ||
  config?.environment?.backendApiUrl ||
  "http://localhost:8080";

export const BASE_FRONTEND_URL = `${protocol}//${host}`;
export const MAX_PARTICIPANTS_NUMBER = 20;

export const generateRoomLink = (invitationCode: string) =>
  `${BASE_FRONTEND_URL}/join/${invitationCode}`;

export const generateParticipantLink = (userCode: string) =>
  `${BASE_FRONTEND_URL}/room/${userCode}`;

export const generateInvitationNoteContent = (
  invitationNote: string,
  invitationCode: string,
) => `${invitationNote}\n${generateRoomLink(invitationCode)}`;

export const removeIdFromArray = <T extends { id?: number }>(
  array: T[],
): Omit<T, "id">[] =>
  array.map((item) => {
    const { id, ...rest } = item;
    void id; // помечаем как "использованную", чтобы ESLint не ругался
    return rest;
  });

export const formatBudget = (budget?: number) => {
  if (budget === undefined || budget === null) return "No data";
  if (budget === 0) return "Unlimited";
  return `${budget} UAH`;
};

export const copyToClipboard = (contentToCopy: string) =>
  navigator.clipboard.writeText(contentToCopy);

export const copyToClipboardWithToaster = (
  contentToCopy: string,
  showToaster: ShowToaster,
  messageConfig: { successMessage: string; errorMessage: string },
) => {
  copyToClipboard(contentToCopy)
    .then(() => showToaster(messageConfig.successMessage, "success", "small"))
    .catch(() => showToaster(messageConfig.errorMessage, "error", "small"));
};

export const formatDate = (dateString?: string) => {
  if (!dateString) return "No data";

  const date = new Date(dateString);
  return date.toLocaleDateString("en-GB", {
    day: "2-digit",
    month: "short",
    year: "numeric",
  });
};
