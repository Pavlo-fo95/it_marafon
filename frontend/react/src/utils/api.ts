async function readErrorBody(res: Response): Promise<string> {
  // сервер для validation problem часто возвращает JSON с полями title/message
  const raw = await res.text().catch(() => "");
  if (!raw) return "";

  try {
    // может быть пустым/не JSON — поэтому try/catch
    const j = JSON.parse(raw) as Record<string, unknown>;
    const title = typeof j.title === "string" ? j.title : undefined;
    const message = typeof j.message === "string" ? j.message : undefined;
    const error = typeof j.error === "string" ? j.error : undefined;
    return title || message || error || raw;
  } catch {
    return raw;
  }
}

export async function apiDelete(
  url: string,
  init?: RequestInit,
): Promise<void> {
  const res = await fetch(url, { method: "DELETE", ...(init ?? {}) });

  // 204 — валидный успех без тела
  if (res.ok || res.status === 204) return;

  const details = await readErrorBody(res);
  throw new Error(
    `HTTP ${res.status} ${res.statusText}${details ? ` — ${details}` : ""}`,
  );
}

export async function apiGet<T>(url: string, init?: RequestInit): Promise<T> {
  const res = await fetch(url, { method: "GET", ...(init ?? {}) });
  if (!res.ok) {
    const details = await readErrorBody(res);
    throw new Error(
      `HTTP ${res.status} ${res.statusText}${details ? ` — ${details}` : ""}`,
    );
  }
  // если бэкенд отдаст пустое тело при 204 — не падать
  if (res.status === 204) return undefined as unknown as T;
  return (await res.json()) as T;
}
