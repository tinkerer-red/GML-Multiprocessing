event_inherited();


if (cp_update_pending)
&& (socket != undefined) {
	cp_update_pending = false;
	__send_cp_update();
}

