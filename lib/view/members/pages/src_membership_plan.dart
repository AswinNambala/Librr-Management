import 'package:flutter/material.dart';
import 'package:librrr_management/core/const_value.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';
import 'package:librrr_management/features/members/widget/members_plan_container.dart';

class MembershipPlan extends StatelessWidget {
  const MembershipPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const AppBarForAll(appBarTitle: 'Membership Plans', navToBorrow: false,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context, 'Base Plan', );
                },
                child: const PlanContainer(
                    planHead: 'Base Plan',
                    planPrice: '₹199',
                    planDetails1: '-  30 days of valid',
                    planDetails2: '-  Maximum $basePlanBookCount books ',
                    planDetails3: '-  Idea for short term period '),
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context, 'Standard Plan');
                },
                child: const PlanContainer(
                    planHead: 'Standard Plan',
                    planPrice: '₹259',
                    planDetails1: '-  90 days of valid',
                    planDetails2: '-  Maximum of $standardPlanBookCount books per month',
                    planDetails3: '-  Good for regular readers'),
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context, 'Premium Plan');
                },
                child: const PlanContainer(
                    planHead: 'Premium Plan',
                    planIcons: Icons.star_rate_sharp,
                    planPrice: '₹499',
                    planDetails1: '-  180 days of valid',
                    planDetails2: '-  Maximum of $maximumBookCount books per month',
                    planDetails3: '-  Best price value for frequent reader'),
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context, 'Elite Plan');
                },
                child: const PlanContainer(
                    planHead: 'Elite Plan',
                    planIcons: Icons.star_rate_sharp,
                    planPrice: '₹799',
                    planDetails1: '-  365 days of valid',
                    planDetails2: '-  Maximum of $maximumBookCount books per month',
                    planDetails3: '-  Prefect for long term reader'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
