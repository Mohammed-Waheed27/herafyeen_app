import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';
import '../../../../../../core/di/injection_container.dart' as di;
import '../../../../../../core/utils/app_snack_bar.dart';
import '../../bloc/worker_requests_bloc.dart';
import '../../bloc/worker_requests_event.dart';
import '../../bloc/worker_requests_state.dart';

class WorkerRequestsPage extends StatefulWidget {
  const WorkerRequestsPage({Key? key}) : super(key: key);

  @override
  State<WorkerRequestsPage> createState() => _WorkerRequestsPageState();
}

class _WorkerRequestsPageState extends State<WorkerRequestsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.sl<WorkerRequestsBloc>()..add(const GetMyWorkRequestsEvent()),
      child: Scaffold(
        backgroundColor: lightColorScheme.onPrimary,
        appBar: AppBar(
          backgroundColor: lightColorScheme.primary,
          title: Text(
            "طلبات العمل",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: lightColorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: lightColorScheme.onPrimary),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            unselectedLabelStyle: Theme.of(context).textTheme.titleMedium,
            tabs: const [
              Tab(text: "الطلبات الجديدة"),
              Tab(text: "السجل"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                if (_tabController.index == 0) {
                  context
                      .read<WorkerRequestsBloc>()
                      .add(const RefreshRequestsEvent());
                } else {
                  context
                      .read<WorkerRequestsBloc>()
                      .add(const GetRequestHistoryEvent());
                }
              },
            ),
          ],
        ),
        body: BlocConsumer<WorkerRequestsBloc, WorkerRequestsState>(
          listener: (context, state) {
            if (state is RequestActionSuccess) {
              AppSnackBar.showSuccess(context, state.message);
            } else if (state is WorkerRequestsError) {
              AppSnackBar.showError(context, state.message);
            }
          },
          builder: (context, state) {
            return TabBarView(
              controller: _tabController,
              children: [
                // Pending requests tab
                _buildPendingRequestsTab(context, state),
                // History tab
                _buildHistoryTab(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPendingRequestsTab(
      BuildContext context, WorkerRequestsState state) {
    if (state is WorkerRequestsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is WorkerRequestsLoaded) {
      return state.requests.isEmpty
          ? _buildEmptyPendingState(context)
          : RefreshIndicator(
              onRefresh: () async {
                context
                    .read<WorkerRequestsBloc>()
                    .add(const RefreshRequestsEvent());
              },
              child: ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: state.requests.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final request = state.requests[index];
                  return _buildRequestCard(context, request, state,
                      isPending: true);
                },
              ),
            );
    }

    if (state is WorkerRequestsError) {
      return _buildErrorState(context, state.message);
    }

    return _buildEmptyPendingState(context);
  }

  Widget _buildHistoryTab(BuildContext context, WorkerRequestsState state) {
    // Load history if not already loaded
    if (state is! RequestHistoryLoaded) {
      context.read<WorkerRequestsBloc>().add(const GetRequestHistoryEvent());
    }

    if (state is WorkerRequestsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is RequestHistoryLoaded) {
      return state.history.isEmpty
          ? _buildEmptyHistoryState(context)
          : RefreshIndicator(
              onRefresh: () async {
                context
                    .read<WorkerRequestsBloc>()
                    .add(const GetRequestHistoryEvent());
              },
              child: ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: state.history.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final request = state.history[index];
                  return _buildRequestCard(context, request, state,
                      isPending: false);
                },
              ),
            );
    }

    return _buildEmptyHistoryState(context);
  }

  Widget _buildRequestCard(
    BuildContext context,
    Map<String, dynamic> request,
    WorkerRequestsState state, {
    required bool isPending,
  }) {
    final String requestId = request['id'] ?? '';
    final String status = request['status'] ?? 'pending';
    final bool isActionLoading =
        state is RequestActionLoading && state.requestId == requestId;

    Color statusColor;
    String statusText;

    switch (status) {
      case 'accepted':
        statusColor = lightColorScheme.tertiary;
        statusText = 'مقبول';
        break;
      case 'rejected':
        statusColor = lightColorScheme.error;
        statusText = 'مرفوض';
        break;
      case 'completed':
        statusColor = Colors.green;
        statusText = 'مكتمل';
        break;
      default:
        statusColor = lightColorScheme.primary;
        statusText = 'جديد';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        request['customerName'] ?? 'عميل غير محدد',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        statusText,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _buildInfoRow(
                  Icons.home_repair_service,
                  "الخدمة: ${request['service'] ?? 'غير محدد'}",
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(
                  Icons.location_on,
                  "الموقع: ${request['location'] ?? 'غير محدد'}",
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(
                  Icons.calendar_today,
                  "التاريخ: ${request['preferredDate'] ?? request['date'] ?? 'غير محدد'}",
                ),
                if (request['preferredTime'] != null) ...[
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    Icons.access_time,
                    "الوقت: ${request['preferredTime']}",
                  ),
                ],
                if (request['budget'] != null) ...[
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    Icons.payment,
                    "الميزانية: ${request['budget']}",
                  ),
                ],
                if (request['payment'] != null && !isPending) ...[
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    Icons.attach_money,
                    "المبلغ المدفوع: ${request['payment']}",
                  ),
                ],
                if (request['description'] != null) ...[
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    Icons.description,
                    "الوصف: ${request['description']}",
                  ),
                ],
                if (request['rating'] != null && request['rating'] > 0) ...[
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16.w),
                      SizedBox(width: 4.w),
                      Text(
                        "التقييم: ${request['rating']}/5",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (isPending && status == 'pending') ...[
            Divider(height: 1, color: lightColorScheme.outline),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: isActionLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: lightColorScheme.primary,
                        strokeWidth: 2.w,
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _showRejectConfirmation(context, requestId);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: lightColorScheme.error,
                              side: BorderSide(color: lightColorScheme.error),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            child: const Text("رفض"),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _showAcceptConfirmation(context, requestId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: lightColorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            child: const Text("قبول"),
                          ),
                        ),
                      ],
                    ),
            ),
          ] else if (status == 'accepted') ...[
            Divider(height: 1, color: lightColorScheme.outline),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isActionLoading
                      ? null
                      : () {
                          _showCompleteConfirmation(context, requestId);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: isActionLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.w,
                          ),
                        )
                      : const Text("إكمال العمل"),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16.w,
          color: lightColorScheme.primary,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: lightColorScheme.surface,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showAcceptConfirmation(BuildContext context, String requestId) {
    _showActionDialog(
      context,
      'قبول الطلب',
      'هل أنت متأكد من أنك تريد قبول هذا الطلب؟',
      'قبول',
      lightColorScheme.primary,
      () =>
          context.read<WorkerRequestsBloc>().add(AcceptRequestEvent(requestId)),
    );
  }

  void _showRejectConfirmation(BuildContext context, String requestId) {
    _showActionDialog(
      context,
      'رفض الطلب',
      'هل أنت متأكد من أنك تريد رفض هذا الطلب؟',
      'رفض',
      lightColorScheme.error,
      () =>
          context.read<WorkerRequestsBloc>().add(RejectRequestEvent(requestId)),
    );
  }

  void _showCompleteConfirmation(BuildContext context, String requestId) {
    _showActionDialog(
      context,
      'إكمال العمل',
      'هل أنت متأكد من أنك قد أكملت هذا العمل؟',
      'إكمال',
      Colors.green,
      () => context
          .read<WorkerRequestsBloc>()
          .add(CompleteRequestEvent(requestId)),
    );
  }

  void _showActionDialog(
    BuildContext context,
    String title,
    String content,
    String actionText,
    Color actionColor,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: lightColorScheme.scrim,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          content: Text(
            content,
            style: TextStyle(
              color: lightColorScheme.surface,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: lightColorScheme.surface,
                  fontSize: 14.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: actionColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                actionText,
                style: TextStyle(
                  color: lightColorScheme.onPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyPendingState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64.w,
              color: lightColorScheme.surface,
            ),
            SizedBox(height: 16.h),
            Text(
              "لا توجد طلبات جديدة",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: lightColorScheme.surface,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              "ستظهر هنا الطلبات الجديدة عندما يقوم العملاء بحجز خدماتك",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: lightColorScheme.surface,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyHistoryState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64.w,
              color: lightColorScheme.surface,
            ),
            SizedBox(height: 16.h),
            Text(
              "لا يوجد سجل للطلبات",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: lightColorScheme.surface,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              "ستظهر هنا الطلبات التي قمت بقبولها أو رفضها أو إكمالها",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: lightColorScheme.surface,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.w,
              color: lightColorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              "حدث خطأ",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: lightColorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: lightColorScheme.surface,
                  ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                context
                    .read<WorkerRequestsBloc>()
                    .add(const GetMyWorkRequestsEvent());
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
