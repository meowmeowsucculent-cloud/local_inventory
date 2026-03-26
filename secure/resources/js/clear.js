$('#add_new_inventory_modal').on('hidden.bs.modal', function () {
  $(this).removeData('bs.modal');
});

$('#add_new_inventory_modal').on('hidden.bs.modal', function () {
    window.location.reload(true);
});

$('#edit_inventory_modal').on('hidden.bs.modal', function () {
  $(this).removeData('bs.modal');
});

$('#edit_inventory_modal').on('hidden.bs.modal', function () {
    window.location.reload(true);
});

$('#inventory_loss_modal').on('hidden.bs.modal', function () {
  $(this).removeData('bs.modal');
});

$('#inventory_loss_modal').on('hidden.bs.modal', function () {
    window.location.reload(true);
});
