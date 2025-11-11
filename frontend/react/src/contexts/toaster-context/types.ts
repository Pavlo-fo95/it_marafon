import type { ToasterHandler } from "../../components/common/toaster/types";

export type ToasterContextValue = {
  // showToast принимает те же аргументы, что и ToasterHandler['show']
  showToast: (...args: Parameters<ToasterHandler["show"]>) => void;
  closeToast: () => void;
};
