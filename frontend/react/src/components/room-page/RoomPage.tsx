import { useEffect } from "react";
import { useParams } from "react-router";
import type {
  GetParticipantsResponse,
  GetRoomResponse,
  DrawRoomResponse,
} from "@types/api";
import Loader from "@components/common/loader/Loader.tsx";
import { useFetch } from "@hooks/useFetch.ts";
import useToaster from "@hooks/useToaster.ts";
import { BASE_API_URL } from "@utils/general.ts";
import { apiDelete } from "@utils/api.ts";
import RoomPageContent from "./room-page-content/RoomPageContent.tsx";
import { ROOM_PAGE_TITLE } from "./utils.ts";
import "./RoomPage.scss";

const RoomPage = () => {
  const { showToast } = useToaster();
  const { userCode } = useParams();

  useEffect(() => {
    document.title = ROOM_PAGE_TITLE;
  }, []);

  const {
    data: roomDetails,
    isLoading: isLoadingRoomDetails,
    fetchData: fetchRoomDetails,
  } = useFetch<GetRoomResponse>(
    { url: `${BASE_API_URL}/api/rooms?userCode=${userCode}`, method: "GET" },
    true,
  );

  const {
    data: participants,
    isLoading: isLoadingParticipants,
    fetchData: fetchParticipants,
  } = useFetch<GetParticipantsResponse>({
    url: `${BASE_API_URL}/api/users?userCode=${userCode}`,
    method: "GET",
  });

  const { fetchData: fetchRandomize, isLoading: isRandomizing } =
    useFetch<DrawRoomResponse>(
      {
        url: `${BASE_API_URL}/api/rooms/draw?userCode=${userCode}`,
        method: "POST",
        onSuccess: () => {
          showToast(
            "Success! All participants are matched.\nLet the gifting magic start!",
            "success",
            "large",
          );
          fetchRoomDetails();
          fetchParticipants();
        },
        onError: () =>
          showToast("Something went wrong. Try again.", "error", "large"),
      },
      false,
    );

  // единая функция удаления, без any/пустых блоков
  const handleDeleteParticipant = async (participantId: number) => {
    if (!userCode) return;

    const url = `${BASE_API_URL}/api/users/${participantId}?userCode=${userCode}`;

    try {
      await apiDelete(url, { headers: { Accept: "application/json" } });
      showToast("Participant removed.", "success", "large");
      await fetchParticipants();
      await fetchRoomDetails();
    } catch (e: unknown) {
      const msg = e instanceof Error ? e.message : "Unknown error";

      console.error("DELETE /api/users failed:", msg);
      showToast(`Failed to remove participant. ${msg}`, "error", "large");
    }
  };

  const isLoading =
    isLoadingRoomDetails || isLoadingParticipants || isRandomizing;

  if (!userCode) return null;

  return (
    <main className="room-page">
      {isLoading ? <Loader /> : null}

      <RoomPageContent
        participants={participants ?? []}
        roomDetails={roomDetails ?? ({} as GetRoomResponse)}
        onDrawNames={() => fetchRandomize()}
        onDeleteParticipant={handleDeleteParticipant}
      />
    </main>
  );
};

export default RoomPage;
