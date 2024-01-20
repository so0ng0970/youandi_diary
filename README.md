<div align="center">
<h2>YOU AND I Diary</h2>

![readme_mockup2](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FcddVd6%2FbtsDHl5nqZ8%2FCpGOYOOIKDwjRFkTQztKkk%2Fimg.jpg)

</div>

## 프로젝트 만든 계기

어릴 적 친구들과 함께 기록했던 다이어리의 추억이 떠올라 <br> 이 프로젝트를 제작하게 되었습니다.
<br>

## 프로젝트 소개

- YOU AND I Diary는 사용자들이 서로 초대를 통해 다이어리를 공유하며, 사진, 동영상, 글 등을 업로드하여 함께 나눌 수 있는 기능을 제공합니다.
- 각 사용자는 다양한 표지 중 원하는 표지를 선택하여 공유 다이어리를 생성하거나, 혼자서만 이용할 다이어리를 만들 수 있습니다.
- 알림 설정을 통해 다른 사용자가 자신의 글에 댓글을 남기면 알림을 받을 수 있습니다.
- 다이어리는 사용자가 현재 날짜로 내부를 표시하며, 달력을 통해 이전에 작성한 글들을 확인할 수 있습니다.
- 사용자는 프로필 사진 또는 닉네임을 변경할 수 있습니다. 또한, 사용자가 다이어리에 남긴 전체 글과 댓글을 한눈에 확인할 수 있습니다.
  <br>

## 1. 개요

- 프로젝트 이름: YOU AND I Diary ✍️
- 프로젝트 기간: 2023.06-2023.11
- 개발 언어: Dart
- 개발자: 김승원
  <br>

## 2. 개발 환경

- Front-end : Flutter, riverpod, json_annotation, retrofit, go_router
- Back-end : firebase
- Design : [Figma](https://www.figma.com/file/mqoSaVF6Oy7s00ftXuCXg4/YOU-%26-I-Diary-UI?type=design&node-id=0%3A1&mode=design&t=Ckjps325O3ymPRyA-1)

<br>

## 3. 페이지별 기능

<br>

### [초기화면 & 회원가입]

- 앱을 시작하면 스플래시 스크린을 통해 몇 초동안 보입니다. 로그인이 이미 완료된 경우, 메인 화면으로 바로 이동하며, 로그인이 되어 있지 않을 경우 로그인 화면이 표시됩니다.
- Authentication를 사용해 회원가입 구현을 진행했습니다.
- 이메일 입력 시, 자동으로 gmail, naver, daum 등의 이메일 형식이 제안되어 사용자가 편리하게 이메일을 설정할 수 있습니다.
- 각 항목에 대해 유효성 검사가 이루어지며, 닉네임은 1-9자 이내, 이메일은 해당 형식에 맞게, 비밀번호는 특수문자, 숫자, 문자를 포함한 8-15자 이내로 설정해야 합니다. 비밀번호 확인 과정에서 입력한 비밀번호와 일치하지 않을 경우, 경고 메시지가 표시됩니다.
- 필요한 정보를 입력하지 않으면, 해당 정보를 입력하라는 메시지가 표시됩니다. 올바른 형식으로 정보를 입력하면 메시지는 바로 사라집니다.

| 초기화면&회원가입 |
| ----------------- |

| splash & sign | sign |
|----------|----------|
|![splash & sign](https://github.com/so0ng0970/youandi_diary/assets/108356773/00ecb367-8699-48ff-8174-956bc2aa6b8e)|![sign](https://github.com/so0ng0970/youandi_diary/assets/108356773/b2169f9e-3afa-4da9-9041-42d8c2e4711f)|


<br>

### [로그인,소셜로그인]

- 로그인은 Firestore에 등록된 회원만 가능하며, 이메일과 비밀번호를 이용하여 진행됩니다.
- 로그인 과정에서도 회원가입처럼 유효성 검사가 이루어지며, 이메일 입력 시 이메일 형식이 자동으로 제안되어 사용자가 편리하게 정보를 입력할 수 있습니다.
- Google 회원들은 'google_sign_in' 라이브러리와 Authentication 설정을 통해 Google 계정으로 소셜 로그인을 진행할 수 있습니다.

| 로그인,소셜로그인 |
| ----------------- |

| login | socialLogin |
|----------|----------|
|![login](https://github.com/so0ng0970/youandi_diary/assets/108356773/12555f0a-af14-472f-89fd-f352872e780d)|![socialLogin](https://github.com/so0ng0970/youandi_diary/assets/108356773/daefd06a-75eb-4fdf-855c-51fcfd2fc156)|


<br>

### [다이어리 제작,친구초대]

- 제목은 최소 한 글자 이상 입력해야 하는 유효성 검사가 설정되어 있습니다.
- 사용자는 원하는 사진을 다이어리 표지로 선택할 수 있으며, 선택하지 않을 경우 초기 설정된 사진이 표지로 사용됩니다.
- Cloud Firestore에 저장된 회원들을 이메일로 검색하여, 원하는 사용자를 다이어리에 추가할 수 있습니다.
- 추가된 사용자들은 프로필 사진, 닉네임, 이메일을 통해 확인할 수 있습니다. 또한, 사진 위에 위치한 'delete' 버튼을 통해 다이어리에서 추가한 사용자를 제거할 수 있습니다.

| 다이어리 제작,친구초대 |
| ----------------- |

| Diary Create | Add User |
|----------|----------|
|![Create](https://github.com/so0ng0970/youandi_diary/assets/108356773/80b5bf67-1d11-4f39-833d-a4815d289485)|![User](https://github.com/so0ng0970/youandi_diary/assets/108356773/8856c8b4-3f7a-4bba-b3f3-a8f958bddf6f)|


<br>

### [다이어리 글 작성,글 수정 & 삭제]

- 글 제목,내용,사진 또는 동영상을 올릴 수 있습니다.
- 사진은 여러장 올릴 수 있으며 슬라이더로 양옆으로 넘기며 볼 수 있습니다.
- 글 수정에서 전에 썼던 글이 보이게 했고 수정과 삭제를 완료시 한번 더 묻는 모달이 나타납니다.
- 수정,삭제는 유저 본인이 쓴 글만 아이콘이 보여 수정,삭제를 할 수 있습니다. 
- 동영상은 재생,일시정지,몇초 뒤,앞으로 가게 하는 버튼을 동영상 클릭시 나타나게 했으며 재생바를 통해 원하는 구간으로 이동하게 하였습니다.

| 다이어리 글 작성,글 수정 & 삭제 (사진) |
| ----------------- |

| Diary post - photo | post edit & delete |
|----------|----------|
|![Diary post - photo](https://github.com/so0ng0970/youandi_diary/assets/108356773/ff5516d7-ed99-4e2a-84d4-cd1fa79bcd94)|![post edit & delete](https://github.com/so0ng0970/youandi_diary/assets/108356773/bf329757-ab8a-4122-953c-662fe51825b0)|

| 다이어리 글 작성, 동영상 재생 (동영상) |
| ----------------- |

| Diary post - video | video play |
|----------|----------|
|![Diary post - video](https://github.com/so0ng0970/youandi_diary/assets/108356773/f3b77d3d-fec3-4e9e-95cb-ed671005d979)|![video play](https://github.com/so0ng0970/youandi_diary/assets/108356773/ac070f62-bc5d-45cc-95e5-84d65d9bcda8)|

<br>

### [댓글 작성,댓글 알림]

- 글 작성과 마찬가지로, 사용자는 본인이 작성한 댓글만 수정하거나 삭제할 수 있습니다. 해당 기능은 사용자만 볼 수 있는 아이콘을 통해 제공됩니다.
- 댓글 알림 기능은 Cloud Function과 firebase_messaging 라이브러리를 활용하여 구현되었습니다.
사용자가 작성한 글에 다른 사용자가 댓글을 달면, 앱이 백그라운드 상태에서도 알림 메시지를 받을 수 있습니다.
- 앱 상단 우측에 위치한 종 모양의 아이콘을 통해 확인하지 않은 알림의 개수를 확인할 수 있습니다. 이 아이콘을 클릭하면 알림 내용을 보여주는 모달이 표시되며, 알림을 확인하면 바로 알림 개수가 없어집니다.
- 알림 아이콘을 클릭하여 모달에서 댓글 알림 내용을 확인할 수 있으며, 왼쪽으로 스와이프하여 알림을 삭제할 수 있습니다.

| 댓글 작성,댓글 알람 |
| ----------------- |

| Comment Writing | Notification |
|----------|----------|
|![댓글쓰기](https://github.com/so0ng0970/youandi_diary/assets/108356773/134bd66e-12c2-4b44-8141-d1eb6662e53f)|![알림](https://github.com/so0ng0970/youandi_diary/assets/108356773/fd220a9f-be75-42cc-b2fc-b4621987f4bd)|


<br>

### [마이페이지 프로필 수정,작성된 글,댓글 모두보기]

- 사용자는 프로필 수정 기능을 통해 닉네임과 프로필 사진을 변경할 수 있습니다.
- 프로필 사진 변경 시에는 앨범에서 원하는 사진을 선택하거나, 앱에 기본으로 설정된 프로필 사진으로 변경할 수 있습니다.
- 'TabBarView'와 'BottomNavigationBar'를 사용하여, 하단 버튼을 클릭하거나 화면을 좌우로 스와이프하여 원하는 페이지로 이동할 수 있습니다.
- 사용자는 모든 다이어리에 작성된 글과 댓글을 한 번에 볼 수 있으며, 삭제 버튼을 통해 여러 개의 글이나 댓글을 한꺼번에 삭제할 수 있습니다.

| 마이페이지 프로필 수정,작성된 글,댓글 모두보기 |
| ----------------- |

| My Page Profile Edit |
|----------|
|![KakaoTalk_20240121_003101278](https://github.com/so0ng0970/youandi_diary/assets/108356773/edbc24bf-4e7b-4360-8933-d333f42b823f)|

| My Page | Posts Comments Delete |
|----------|----------|
|![KakaoTalk_20240121_003101278_02](https://github.com/so0ng0970/youandi_diary/assets/108356773/cdced96c-4a47-4d39-abe8-ccc1f844d619)|![알림](https://github.com/so0ng0970/youandi_diary/assets/108356773/fd220a9f-be75-42cc-b2fc-b4621987f4bd)|


<br>