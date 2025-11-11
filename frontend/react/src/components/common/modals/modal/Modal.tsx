import { useEffect } from "react";
import { createPortal } from "react-dom";
import IconButton from "@components/common/icon-button/IconButton";
import Button from "@components/common/button/Button";
import type { ModalProps } from "./types";
import "@assets/styles/common/modal-container.scss";
import "./Modal.scss";

const Modal = ({
  title,
  description,
  subdescription,
  iconName,
  isOpen = false,
  onClose,
  onConfirm,
  children,
}: ModalProps) => {
  useEffect(() => {
    document.body.style.overflow = isOpen ? "hidden" : "";
    return () => {
      document.body.style.overflow = "";
    };
  }, [isOpen]);

  if (!isOpen) return null;

  const modalElement = (
    <div className="modal-container">
      <div className="modal">
        <div className={`modal__heading modal__heading--${iconName}`}>
          <h3 className="modal__title">{title}</h3>
          <p className="modal__description">{description}</p>
          {subdescription ? (
            <p className="modal__subdescription">{subdescription}</p>
          ) : null}
        </div>

        {/* кнопка закрытия */}
        <div className="modal__close-button">
          <IconButton iconName="cross" onClick={onClose} />
        </div>

        {/* контент модалки */}
        {children}

        {/* кнопки действий */}
        <div className="modal__actions">
          <Button
            size="medium"
            variant="danger"
            width={180}
            onClick={onConfirm}
          >
            Delete
          </Button>
          <Button size="medium" width={225} onClick={onClose}>
            Go Back to Room
          </Button>
        </div>
      </div>
    </div>
  );

  return createPortal(modalElement, document.body);
};

export default Modal;
