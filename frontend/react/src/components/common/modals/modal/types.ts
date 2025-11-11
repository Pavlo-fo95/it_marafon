import type { ReactNode } from "react";

export const ICON_NAMES = {
  PRESENTS: "presents",
  COOKIE: "cookie",
  NOTE: "note",
  CAR: "car",
  INFO: "info",
  CROSS: "cross",
} as const;

export type IconName = (typeof ICON_NAMES)[keyof typeof ICON_NAMES];

export interface ModalProps {
  title: string;
  description: string;
  subdescription?: string;
  iconName: IconName;
  isOpen?: boolean;
  onClose: () => void;
  onConfirm: () => void;
  children: ReactNode;

  confirmText?: string;
  cancelText?: string;
  showCancel?: boolean;
}
