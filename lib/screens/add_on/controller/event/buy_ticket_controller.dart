import 'package:foap/model/user_model.dart';
import 'package:foap/screens/settings_menu/settings_controller.dart';
import 'package:get/get.dart';
import 'package:foap/helper/imports/event_imports.dart';


class BuyTicketController extends GetxController {
  RxInt numberOfTickets = 1.obs;
  Rx<EventTicketType?> selectedTicketType = Rx<EventTicketType?>(null);
  Rx<EventCoupon?> selectedCoupon = Rx<EventCoupon?>(null);
  final SettingsController _settingsController = Get.find();
  UserModel? giftToUser;
  late EventModel event;
  EventCoupon? coupon;

  double get amountToBePaid {
    return (selectedTicketType.value!.price * numberOfTickets.value) -
        (selectedCoupon.value == null ? 0 : selectedCoupon.value!.discount) +
        _settingsController.setting.value!.serviceFee;
  }

  EventTicketOrderRequest get ticketOrder {
    EventTicketOrderRequest ticketOrder = EventTicketOrderRequest(payments: []);

    ticketOrder.eventId = event.id;
    ticketOrder.qty = numberOfTickets.value;
    ticketOrder.eventTicketTypeId = selectedTicketType.value?.id;
    ticketOrder.coupon = coupon?.code ?? '';
    ticketOrder.discount = coupon?.discount ?? 0;
    ticketOrder.itemName = event.name;
    ticketOrder.gifToUser = giftToUser;

    ticketOrder.ticketAmount =
        (selectedTicketType.value?.price ?? 0) * numberOfTickets.value;
    ticketOrder.amountToBePaid = ((selectedTicketType.value?.price ?? 0) *
            numberOfTickets.value) -
        (selectedCoupon.value == null ? 0 : selectedCoupon.value!.discount) +
        (_settingsController.setting.value?.serviceFee ?? 0);

    return ticketOrder;
  }

  setData({required EventModel event,UserModel? giftToUser}) {
    this.event = event;
    this.giftToUser = giftToUser;
  }

  selectTicketType(EventTicketType type) {
    if (selectedTicketType.value != type) {
      removeAllTickets();
    }
    selectedTicketType.value = type;

    // ticketOrder.eventId = event.id;
    // ticketOrder.eventTicketTypeId = type.id;
  }

  selectEventCoupon(EventCoupon coupon) {
    if (coupon.minimumOrderPrice <=
        selectedTicketType.value!.price * numberOfTickets.value) {
      selectedCoupon.value = coupon;
      this.coupon = coupon;
      // ticketOrder.coupon = coupon.code;
      // ticketOrder.discount = coupon.discount;
    }
  }

  addTicket() {
    if (selectedTicketType.value!.availableTicket > numberOfTickets.value) {
      numberOfTickets.value += 1;
      // ticketOrder.ticketAmount =
      //     selectedTicketType.value!.price * numberOfTickets.value;
    }
  }

  removeAllTickets() {
    numberOfTickets.value = 1;

    if (selectedCoupon.value != null) {
      if (selectedCoupon.value!.minimumOrderPrice >
          selectedTicketType.value!.price * numberOfTickets.value) {
        selectedCoupon.value = null;

        // ticketOrder.coupon = null;
        // ticketOrder.discount = null;
        // ticketOrder.ticketAmount =
        //     selectedTicketType.value!.price * numberOfTickets.value;
      }
    }
  }

  removeTicket() {
    if (numberOfTickets.value > 1) {
      numberOfTickets.value -= 1;

      if (selectedCoupon.value != null) {
        if (selectedCoupon.value!.minimumOrderPrice >
            selectedTicketType.value!.price * numberOfTickets.value) {
          selectedCoupon.value = null;
          // ticketOrder.coupon = null;
          // ticketOrder.discount = null;
        }
      }

      // ticketOrder.qty = numberOfTickets.value;
      // ticketOrder.ticketAmount =
      //     selectedTicketType.value!.price * numberOfTickets.value;
    }
  }
}
