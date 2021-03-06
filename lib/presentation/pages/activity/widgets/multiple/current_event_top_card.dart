import 'package:dashtech/application/activity/activity_controller.dart';
import 'package:dashtech/application/activity/multiple_event_activity_controller.dart';
import 'package:dashtech/presentation/core/theme/app_colors.dart';
import 'package:dashtech/presentation/shared/activity_color_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class CurrentEventTopCard extends GetView<MultipleEventActivityController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0xFF464646).withOpacity(0.2),
            blurRadius: 15.0,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: Get.width - 20,
          color: ActivityColorUtils.getColorByEventType(
            controller.activityController.activity.value.type_code,
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Obx(
                      () => Visibility(
                        visible: controller.getStudentStatus() != null,
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Icon(
                            LineIcons.hand_stop_o,
                            color: Color(
                              controller.getStudentStatus() == "present"
                                  ? successColor
                                  : warnColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.activityController.activity.value.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            controller.parseDateByEvent(
                                controller.selectedEvent.value),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: Get.width / 2,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Obx(
                      () => Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            controller.activityController.parseActivityTime(
                                controller.selectedEvent.value.begin),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 25,
                          ),
                          Text(
                            controller.activityController.parseActivityTime(
                                controller.selectedEvent.value.end),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Obx(
                    () => Text(
                      controller.parseActivityRoom(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
