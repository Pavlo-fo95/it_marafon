import type { ButtonProps } from "./types.ts";
import "./Button.scss";

const Button = ({
  variant = "primary",
  size = "medium",
  width,
  className = "",
  ...rest
}: ButtonProps) => {
  const style = width ? { width } : undefined;

  return (
    <button
      className={[
        "button",
        `button--${variant}`,
        `button--${size}`,
        className,
      ].join(" ")}
      style={style}
      {...rest}
    />
  );
};

export default Button;
