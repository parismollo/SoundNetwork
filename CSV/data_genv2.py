from faker import Faker
import csv
import random

fake = Faker()

# Constants
num_users = 100
num_places = 30
num_concerts = 50
num_playlists = 50
num_music = 200
num_posts = 100
num_reviews = 100
num_comments = 200
num_tags = 50
num_actions = 200
num_user_page = 100

user_ids = list(range(1, num_users + 1))
place_ids = list(range(1, num_places + 1))
concert_ids = list(range(1, num_concerts + 1))
playlist_ids = list(range(1, num_playlists + 1))
music_ids = list(range(1, num_music + 1))
post_ids = list(range(1, num_posts + 1))
review_ids = list(range(1, num_reviews + 1))
comment_ids = list(range(1, num_comments + 1))
tag_ids = list(range(1, num_tags + 1))
action_ids = list(range(1, num_actions + 1))
user_page_ids = list(range(1, num_user_page + 1))

unique_names = set()

# user
with open('CSV/user.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    for _ in range(num_users):
        name = fake.name()
        while name in unique_names:  # Ensuring unique names
            name = fake.name()
        unique_names.add(name)
        writer.writerow([name])

# follow and friendship
with open('CSV/follow.csv', 'w', newline='') as file, open('CSV/friendship.csv', 'w', newline='') as file2:
    writer1 = csv.writer(file)
    writer2 = csv.writer(file2)
    for i in range(1, num_users + 1):
        # let each user follow and befriend the next user, with ids wrapping around at the end
        writer1.writerow([i, i % num_users + 1])
        writer2.writerow([i, i % num_users + 1])

# event, group, person, place and concertHall
with open('CSV/event.csv', 'w', newline='') as file, open('CSV/group.csv', 'w', newline='') as file2, open('CSV/person.csv', 'w', newline='') as file3, open('CSV/place.csv', 'w', newline='') as file4, open('CSV/concertHall.csv', 'w', newline='') as file5:
    writer1 = csv.writer(file)
    writer2 = csv.writer(file2)
    writer3 = csv.writer(file3)
    writer4 = csv.writer(file4)
    writer5 = csv.writer(file5)
    for i in range(1, num_users + 1):
        writer1.writerow([i])
        writer2.writerow([i])
        writer3.writerow([i])
        writer4.writerow([i, fake.address().replace("\n", ", ")])
        if i <= num_places:  # Creating only 'num_places' concert halls
            writer5.writerow([i, fake.company()])

# associations, user_page
with open('CSV/associations.csv', 'w', newline='') as file:
    writer1 = csv.writer(file)
    for i in range(1, num_users + 1):
        writer1.writerow([i])


# music
with open('CSV/music.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    for i in music_ids:
        writer.writerow([i, random.choice(user_ids), fake.bs()])

# post, review
with open('CSV/post.csv', 'w', newline='') as file, open('CSV/review.csv', 'w', newline='') as file2:
    writer1 = csv.writer(file)
    writer2 = csv.writer(file2)
    for i in post_ids:
        writer1.writerow([i, random.choice(user_ids), fake.text(), random.choice(user_page_ids)])
    for i in review_ids:
        writer2.writerow([i, random.choice(user_ids), fake.text(), random.choice(music_ids)])

# comment
with open('CSV/comment.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    for i in comment_ids:
        writer.writerow([i, random.choice(user_ids), fake.text(), random.choice(post_ids)])

# music_tag, post_tag
with open('CSV/music_tag.csv', 'w', newline='') as file, open('CSV/post_tag.csv', 'w', newline='') as file2:
    writer1 = csv.writer(file)
    writer2 = csv.writer(file2)
    for i in music_ids:
        writer1.writerow([i, random.choice(tag_ids)])
    for i in post_ids:
        writer2.writerow([i, random.choice(tag_ids)])

# action
with open('CSV/action.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    actions = ['interessé', 'participe']
    for i in action_ids:
        writer.writerow([i, random.choice(actions), random.choice(user_ids), random.choice(concert_ids)])

# tags
with open('CSV/tag.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    genres = ['Rock', 'Pop', 'Hip Hop', 'Jazz', 'Classical', 'Country', 'Electronic']
    sub_genres = ['Alternative Rock', 'Pop Rock', 'Trap', 'Smooth Jazz', 'Baroque', 'Bluegrass', 'Ambient']
    for i in range(1, num_tags + 1):
        writer.writerow([i, random.choice(genres+sub_genres)])

# user_page
with open('CSV/user_page.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    for i in range(1, num_user_page + 1):
        writer.writerow([i, random.randint(1, num_users)])

# playlist
with open('CSV/playlist.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    for i in range(1, num_playlists + 1):
        writer.writerow([i, random.randint(1, num_users), fake.bs(), random.randint(1, num_user_page)])

# concert
with open('CSV/concert.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    for i in concert_ids:
        price = random.randint(10, 100)
        organizers = random.choice(user_ids)
        lineup = ",".join([str(random.choice(user_ids)) for _ in range(random.randint(1, 5))])  # Making lineup a comma-separated string
        available_seats = random.randint(50, 500)
        place = random.choice(place_ids)
        need_volunteers = random.choice([True, False])
        supporting_cause = fake.text(max_nb_chars=200)
        outdoor_space = random.choice([True, False])
        child_allowed = random.choice([True, False])
        writer.writerow([i, price, organizers, lineup, available_seats, place, need_volunteers, supporting_cause, outdoor_space, child_allowed])