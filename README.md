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

- 앱을 시작하면 스플래시 스크린을 통해 환영의 메시지를 전달합니다. 로그인이 이미 완료된 경우, 메인 화면으로 바로 이동하며, 로그인이 되어 있지 않을 경우 로그인 화면이 표시됩니다.
- 이메일 입력 시, 자동으로 gmail, naver, daum 등의 이메일 형식이 제안되어 사용자가 편리하게 이메일을 설정할 수 있습니다.
- 각 항목에 대해 유효성 검사가 이루어지며, 닉네임은 1-9자 이내, 이메일은 해당 형식에 맞게, 비밀번호는 특수문자, 숫자, 문자를 포함한 8-15자 이내로 설정해야 합니다. 비밀번호 확인 과정에서 입력한 비밀번호와 일치하지 않을 경우, 경고 메시지가 표시됩니다.
- 필요한 정보를 입력하지 않으면, 해당 정보를 입력하라는 메시지가 표시됩니다. 올바른 형식으로 정보를 입력하면 메시지는 바로 사라집니다.

| 초기화면&회원가입 |
| ----------------- |

![splash](https://blog.kakaocdn.net/dn/nZatz/btsDGYKOAq7/8l2yJkR9bfhSY5BBfEsUJK/img.gif)

<br>
